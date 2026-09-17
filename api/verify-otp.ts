import {
  EMAIL_REGEX,
  MAX_ATTEMPTS,
  OTP_TTL_MS,
  type RouteResult,
  auth,
  db,
  sha256,
} from './_lib/firebase';

export async function handleVerifyOtp(payload: any): Promise<RouteResult> {
  try {
    const email = String(payload?.email || '').trim().toLowerCase();
    const code = String(payload?.code || '').trim();

    if (!EMAIL_REGEX.test(email)) {
      return { status: 400, body: { error: 'Invalid email address' } };
    }
    if (!/^\d{4}$/.test(code)) {
      return { status: 400, body: { error: 'Code must be 4 digits' } };
    }

    const ref = db.collection('otpRequests').doc(email);
    const snap = await ref.get();

    if (!snap.exists) {
      return {
        status: 404,
        body: { error: 'No code requested for this email' },
      };
    }

    const data = snap.data()!;
    const expiresAt =
      typeof data.expiresAt === 'number'
        ? data.expiresAt
        : data.expiresAt?.toMillis?.() ?? 0;

    if (Date.now() > expiresAt) {
      await ref.delete();
      return { status: 410, body: { error: 'Code has expired' } };
    }

    const attempts = data.attempts ?? 0;
    if (attempts >= MAX_ATTEMPTS) {
      await ref.delete();
      return {
        status: 429,
        body: { error: 'Too many attempts, request a new code' },
      };
    }

    if (data.codeHash !== sha256(code)) {
      await ref.update({ attempts: attempts + 1 });
      return { status: 401, body: { error: 'Incorrect code' } };
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

    return { status: 200, body: { success: true, token } };
  } catch (error: any) {
    console.error('verifyOtp error', error);
    return {
      status: 500,
      body: { error: error?.message || 'Something went wrong' },
    };
  }
}
