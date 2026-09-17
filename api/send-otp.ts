import type { VercelRequest, VercelResponse } from '@vercel/node';

import {
  COOLDOWN_MS,
  EMAIL_REGEX,
  db,
  genOtp,
  sendEmail,
  sendJson,
  sha256,
  OTP_TTL_MS,
} from './_lib/firebase';

export default async function handler(
  req: VercelRequest,
  res: VercelResponse,
) {
  if (req.method === 'OPTIONS') {
    return sendJson(res, 204, {});
  }
  if (req.method !== 'POST') {
    return sendJson(res, 405, { error: 'Method not allowed' });
  }

  try {
    const email = String(req.body?.email || '').trim().toLowerCase();
    if (!EMAIL_REGEX.test(email)) {
      return sendJson(res, 400, { error: 'Invalid email address' });
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
        return sendJson(res, 429, {
          error: 'Please wait a moment before requesting a new code',
        });
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

    return sendJson(res, 200, { success: true });
  } catch (error: any) {
    console.error('sendOtp error', error);
    return sendJson(res, 500, {
      error: error?.message || 'Something went wrong',
    });
  }
}