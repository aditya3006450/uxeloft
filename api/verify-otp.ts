import {
  CORS_HEADERS,
  EMAIL_REGEX,
  MAX_ATTEMPTS,
  OTP_TTL_MS,
  auth,
  db,
  json,
  sha256,
} from './_lib/firebase';

export function OPTIONS(): Response {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

export async function POST(request: Request): Promise<Response> {
  try {
    let body: { email?: string; code?: string };
    try {
      body = (await request.json()) as { email?: string; code?: string };
    } catch {
      return json({ error: 'Invalid JSON body' }, 400);
    }

    const email = String(body?.email || '').trim().toLowerCase();
    const code = String(body?.code || '').trim();

    if (!EMAIL_REGEX.test(email)) {
      return json({ error: 'Invalid email address' }, 400);
    }
    if (!/^\d{4}$/.test(code)) {
      return json({ error: 'Code must be 4 digits' }, 400);
    }

    const ref = db.collection('otpRequests').doc(email);
    const snap = await ref.get();

    if (!snap.exists) {
      return json({ error: 'No code requested for this email' }, 404);
    }

    const data = snap.data()!;
    const expiresAt =
      typeof data.expiresAt === 'number'
        ? data.expiresAt
        : data.expiresAt?.toMillis?.() ?? 0;

    if (Date.now() > expiresAt) {
      await ref.delete();
      return json({ error: 'Code has expired' }, 410);
    }

    const attempts = data.attempts ?? 0;
    if (attempts >= MAX_ATTEMPTS) {
      await ref.delete();
      return json({ error: 'Too many attempts, request a new code' }, 429);
    }

    if (data.codeHash !== sha256(code)) {
      await ref.update({ attempts: attempts + 1 });
      return json({ error: 'Incorrect code' }, 401);
    }

    await ref.delete();

    let uid: string;
    try {
      const user = await auth.getUserByEmail(email);
      uid = user.uid;
    } catch (error: any) {
      if (error?.code !== 'auth/user-not-found') {
        throw error;
      }
      const created = await auth.createUser({ email });
      uid = created.uid;
    }

    const token = await auth.createCustomToken(uid);

    return json({ success: true, token });
  } catch (error: any) {
    console.error('verifyOtp error', error);
    return json({ error: error?.message || 'Something went wrong' }, 500);
  }
}
