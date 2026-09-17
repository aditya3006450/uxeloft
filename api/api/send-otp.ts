import {
  COOLDOWN_MS,
  CORS_HEADERS,
  EMAIL_REGEX,
  OTP_TTL_MS,
  db,
  genOtp,
  json,
  sendEmail,
  sha256,
} from './_lib/firebase';

export function OPTIONS(): Response {
  return new Response(null, { status: 204, headers: CORS_HEADERS });
}

export async function POST(request: Request): Promise<Response> {
  try {
    let body: { email?: string };
    try {
      body = (await request.json()) as { email?: string };
    } catch {
      return json({ error: 'Invalid JSON body' }, 400);
    }

    const email = String(body?.email || '').trim().toLowerCase();
    if (!EMAIL_REGEX.test(email)) {
      return json({ error: 'Invalid email address' }, 400);
    }

    const ref = db.collection('otpRequests').doc(email);
    const existing = await ref.get();

    if (existing.exists) {
      const data = existing.data()!;
      const createdAt =
        typeof data.createdAt === 'number'
          ? data.createdAt
          : data.createdAt?.toMillis?.() ?? 0;
      if (Date.now() - createdAt < COOLDOWN_MS) {
        return json(
          { error: 'Please wait a moment before requesting a new code' },
          429,
        );
      }
    }

    const otp = genOtp();
    await ref.set({
      codeHash: sha256(otp),
      expiresAt: Date.now() + OTP_TTL_MS,
      attempts: 0,
      createdAt: Date.now(),
    });

    await sendEmail(email, otp);

    return json({ success: true });
  } catch (error: any) {
    console.error('sendOtp error', error);
    return json({ error: error?.message || 'Something went wrong' }, 500);
  }
}
