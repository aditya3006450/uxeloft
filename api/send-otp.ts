import { sendEmail } from './_lib/mailer';
import {
  EMAIL_REGEX,
  type RouteResult,
  canSendNow,
  generateOtp,
  markSent,
} from './_lib/otp';

export async function handleSendOtp(payload: any): Promise<RouteResult> {
  try {
    const email = String(payload?.email || '').trim().toLowerCase();
    if (!EMAIL_REGEX.test(email)) {
      return { status: 400, body: { error: 'Invalid email address' } };
    }

    if (!canSendNow(email)) {
      return {
        status: 429,
        body: { error: 'Please wait a moment before requesting a new code' },
      };
    }

    const otp = generateOtp(email);
    await sendEmail(email, otp);
    markSent(email);

    return { status: 200, body: { success: true } };
  } catch (error: any) {
    console.error('sendOtp error', error);
    return {
      status: 500,
      body: { error: error?.message || 'Something went wrong' },
    };
  }
}
