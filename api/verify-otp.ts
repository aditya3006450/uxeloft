import type { VercelRequest, VercelResponse } from '@vercel/node';

import {
  EMAIL_REGEX,
  MAX_ATTEMPTS,
  OTP_TTL_MS,
  auth,
  db,
  sendJson,
  sha256,
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
    const code = String(req.body?.code || '').trim();

    if (!EMAIL_REGEX.test(email)) {
      return sendJson(res, 400, { error: 'Invalid email address' });
    }
    if (!/^\d{4}$/.test(code)) {
      return sendJson(res, 400, { error: 'Code must be 4 digits' });
    }

    const ref = db.collection('otpRequests').doc(email);
    const snap = await ref.get();

    if (!snap.exists) {
      return sendJson(res, 404, {
        error: 'No code requested for this email',
      });
    }

    const data = snap.data()!;
    const expiresAt =
      typeof data.expiresAt === 'number'
        ? data.expiresAt
        : data.expiresAt?.toMillis?.() ?? 0;

    if (Date.now() > expiresAt) {
      await ref.delete();
      return sendJson(res, 410, { error: 'Code has expired' });
    }

    const attempts = data.attempts ?? 0;
    if (attempts >= MAX_ATTEMPTS) {
      await ref.delete();
      return sendJson(res, 429, {
        error: 'Too many attempts, request a new code',
      });
    }

    if (data.codeHash !== sha256(code)) {
      await ref.update({ attempts: attempts + 1 });
      return sendJson(res, 401, { error: 'Incorrect code' });
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

    return sendJson(res, 200, { success: true, token });
  } catch (error: any) {
    console.error('verifyOtp error', error);
    return sendJson(res, 500, {
      error: error?.message || 'Something went wrong',
    });
  }
}