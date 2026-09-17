import { createHmac } from 'node:crypto';

export const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
export const OTP_TTL_MS = 5 * 60 * 1000;
export const COOLDOWN_MS = 30 * 1000;

export type RouteResult = { status: number; body: unknown };

function getSecret(): string {
  const secret = process.env.OTP_SECRET;
  if (!secret) {
    throw new Error('OTP_SECRET is not configured');
  }
  return secret;
}

function codeForWindow(email: string, window: number): string {
  const digest = createHmac('sha256', getSecret())
    .update(`${email}:${window}`)
    .digest();
  return String(digest.readUInt32BE(0) % 10000).padStart(4, '0');
}

export function generateOtp(email: string, at: number = Date.now()): string {
  return codeForWindow(email, Math.floor(at / OTP_TTL_MS));
}

function safeEqual(a: string, b: string): boolean {
  if (a.length !== b.length) {
    return false;
  }
  let diff = 0;
  for (let i = 0; i < a.length; i++) {
    diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return diff === 0;
}

export function isOtpValid(
  email: string,
  code: string,
  at: number = Date.now(),
): boolean {
  const current = generateOtp(email, at);
  const previous = generateOtp(email, at - OTP_TTL_MS);
  return safeEqual(code, current) || safeEqual(code, previous);
}

const lastSent = new Map<string, number>();

export function canSendNow(email: string, at: number = Date.now()): boolean {
  const last = lastSent.get(email);
  return last === undefined || at - last >= COOLDOWN_MS;
}

export function markSent(email: string, at: number = Date.now()): void {
  lastSent.set(email, at);
}
