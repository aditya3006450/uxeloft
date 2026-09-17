import nodemailer, { type Transporter } from 'nodemailer';

let transporter: Transporter | null = null;

function getTransporter(): Transporter {
  const user = process.env.GMAIL_USER;
  const pass = process.env.GMAIL_PASS;
  if (!user || !pass) {
    throw new Error('Gmail SMTP is not configured (GMAIL_USER / GMAIL_PASS)');
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
