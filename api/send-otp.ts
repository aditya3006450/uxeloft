import {
  COOLDOWN_MS,
  EMAIL_REGEX,
  OTP_TTL_MS,
  type RouteResult,
  db,
  genOtp,
  sendEmail,
  sha256,
} from './_lib/firebase';

export async function handleSendOtp(payload: any): Promise<RouteResult> {
  try {
    const email = String(payload?.email || '').trim().toLowerCase();
    if (!EMAIL_REGEX.test(email)) {
      return { status: 400, body: { error: 'Invalid email address' } };
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
        return {
          status: 429,
          body: { error: 'Please wait a moment before requesting a new code' },
        };
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

    return { status: 200, body: { success: true } };
  } catch (error: any) {
    console.error('sendOtp error', error);
    return {
      status: 500,
      body: { error: error?.message || 'Something went wrong' },
    };
  }
}
