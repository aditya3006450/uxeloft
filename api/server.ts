import { createServer, type IncomingMessage, type ServerResponse } from 'node:http';

import { handleSendOtp } from './send-otp';
import { handleVerifyOtp } from './verify-otp';

const CORS_HEADERS: Record<string, string> = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function sendJson(
  res: ServerResponse,
  status: number,
  body: unknown,
): void {
  res.writeHead(status, {
    'Content-Type': 'application/json',
    ...CORS_HEADERS,
  });
  res.end(JSON.stringify(body));
}

async function readJson(req: IncomingMessage): Promise<any> {
  let raw = '';
  for await (const chunk of req) {
    raw += (chunk as Buffer).toString('utf8');
  }
  return raw.length === 0 ? {} : JSON.parse(raw);
}

async function handle(req: IncomingMessage, res: ServerResponse): Promise<void> {
  const method = req.method ?? 'GET';
  const path = new URL(
    req.url ?? '/',
    `http://${req.headers.host ?? 'localhost'}`,
  ).pathname;

  if (method === 'OPTIONS') {
    res.writeHead(204, CORS_HEADERS);
    res.end();
    return;
  }

  if (method === 'GET' && (path === '/' || path === '/api')) {
    sendJson(res, 200, { status: 'okay' });
    return;
  }

  if (path === '/api/send-otp' || path === '/send-otp') {
    if (method !== 'POST') {
      sendJson(res, 405, { error: 'Method not allowed' });
      return;
    }
    let payload: any;
    try {
      payload = await readJson(req);
    } catch {
      sendJson(res, 400, { error: 'Invalid JSON body' });
      return;
    }
    const result = await handleSendOtp(payload);
    sendJson(res, result.status, result.body);
    return;
  }

  if (path === '/api/verify-otp' || path === '/verify-otp') {
    if (method !== 'POST') {
      sendJson(res, 405, { error: 'Method not allowed' });
      return;
    }
    let payload: any;
    try {
      payload = await readJson(req);
    } catch {
      sendJson(res, 400, { error: 'Invalid JSON body' });
      return;
    }
    const result = await handleVerifyOtp(payload);
    sendJson(res, result.status, result.body);
    return;
  }

  sendJson(res, 404, { error: 'Not found' });
}

const server = createServer((req, res) => {
  handle(req, res).catch((error) => {
    console.error('server error', error);
    if (!res.headersSent) {
      sendJson(res, 500, { error: 'Internal server error' });
    }
  });
});

server.listen(Number(process.env.PORT ?? 3000));
