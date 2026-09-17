import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { getAuth } from 'firebase-admin/auth';
import { getFirestore } from 'firebase-admin/firestore';

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
  return String(Math.floor(Math.random() * 10 ** 6)).padStart(6, '0');
}

export const sha256 = (input: string): string => {
  const { createHash } = require('crypto');
  return createHash('sha256').update(input).digest('hex');
};

export function sendJson(res: any, status: number, body: object): any {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  return res.status(status).json(body);
}

export async function sendEmail(to: string, otp: string): Promise<void> {
  const apiKey = process.env.RESEND_API_KEY;
  const from = process.env.RESEND_FROM || 'Uxeloft <onboarding@resend.dev>';

  if (!apiKey) {
    throw new Error('Email service is not configured (RESEND_API_KEY)');
  }

  const response = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from,
      to,
      subject: 'Your Uxeloft verification code',
      text: `Your Uxeloft verification code is ${otp}. It expires in 5 minutes.`,
      html: `<p>Your Uxeloft verification code is <b>${otp}</b>.<br/>It expires in 5 minutes.</p>`,
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Failed to send email: ${body}`);
  }
}