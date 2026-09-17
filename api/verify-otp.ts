import { EMAIL_REGEX, type RouteResult, isOtpValid } from './_lib/otp';

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

    if (!isOtpValid(email, code)) {
      return {
        status: 401,
        body: { error: 'Incorrect or expired code' },
      };
    }

    return { status: 200, body: { success: true } };
  } catch (error: any) {
    console.error('verifyOtp error', error);
    return {
      status: 500,
      body: { error: error?.message || 'Something went wrong' },
    };
  }
}
