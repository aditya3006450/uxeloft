import { createHash } from 'node:crypto';

import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';
import nodemailer, { type Transporter } from 'nodemailer';

function resolveSecret(value: string | undefined): string {
  if (!value) {
    throw new Error('Missing required Firebase service account secret');
  }
  if (value.startsWith('base64:')) {
    return Buffer.from(value.slice(7), 'base64').toString('utf8');
  }
  return value.replace(/\\n/g, '\n');
}

function getApp() {
  const existing = getApps().find((app) => app.name === 'uxeloft');
  if (existing) {
    return existing;
  }

  const projectId = process.env.FIREBASE_PROJECT_ID;
  const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
  const privateKey = process.env.FIREBASE_PRIVATE_KEY;

  const options =
    projectId && clientEmail && privateKey
      ? {
          projectId,
          credential: cert({
            projectId,
            clientEmail,
            privateKey: resolveSecret(privateKey),
          }),
        }
      : { projectId };

  return initializeApp(options, 'uxeloft');
}

export const adminApp = getApp();
export const db = getFirestore(adminApp);
export const auth = getAuth(adminApp);

export const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
export const OTP_TTL_MS = 5 * 60 * 1000;
export const COOLDOWN_MS = 30 * 1000;
export const MAX_ATTEMPTS = 5;

export function genOtp(): string {
  return String(Math.floor(Math.random() * 10 ** 4)).padStart(4, '0');
}

export const sha256 = (input: string): string =>
  createHash('sha256').update(input).digest('hex');

export type RouteResult = { status: number; body: unknown };

let transporter: Transporter | null = null;

function getTransporter(): Transporter {
  const user = process.env.GMAIL_USER;
  const pass = process.env.GMAIL_PASS;
  if (!user || !pass) {
    throw new Error(
      'Gmail SMTP is not configured (GMAIL_USER / GMAIL_PASS)',
    );
  }
  if (!transporter) {
    transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: { user, pass },
    });
  }
  return transporter;
}

export async function sendEmail(to: string, otp: string): Promise<void> {
  const user = process.env.GMAIL_USER;
  const transport = getTransporter();

  await transport.sendMail({
    from: `Uxeloft <${user}>`,
    to,
    subject: 'Your Uxeloft verification code',
    text: `Your Uxeloft verification code is ${otp}. It expires in 5 minutes.`,
    html: `<p>Your Uxeloft verification code is <b>${otp}</b>.<br/>It expires in 5 minutes.</p>`,
  });
}