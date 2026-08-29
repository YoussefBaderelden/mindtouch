#!/usr/bin/env node
/**
 * Local MindTouch API server — same routes as Vercel, no Vercel login required.
 * Serves admin dashboard + phone control API on one port.
 */
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { cors, readBody } from '../api/_lib/cors.js';
import { PHONE_ACTIONS, DIRECTIONS, DIRECTION_MAP } from '../api/_lib/actions.js';
import {
  registerPhone,
  listPhones,
  sendCommand,
  addLog,
  getLogs,
  dequeueCommand,
  isUsingMemoryStore,
} from '../api/_lib/store.js';
import { registerUser, loginUser, getUserFromToken, listUsers } from '../api/_lib/auth.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.join(__dirname, '..');
const PORT = process.env.PORT || 3000;

function json(res, status, data) {
  cors(res);
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

async function handleApi(req, res, url) {
  if (req.method === 'OPTIONS') {
    cors(res);
    res.writeHead(200);
    res.end();
    return;
  }

  if (url.pathname === '/api/auth/register' && req.method === 'POST') {
    const body = await readBody(req);
    const result = await registerUser(body);
    if (result.error) return json(res, result.status, { error: result.error });
    return json(res, 200, result.data);
  }

  if (url.pathname === '/api/auth/login' && req.method === 'POST') {
    const body = await readBody(req);
    const result = await loginUser(body);
    if (result.error) return json(res, result.status, { error: result.error });
    return json(res, 200, result.data);
  }

  if (url.pathname === '/api/auth/me' && req.method === 'GET') {
    const token = req.headers.authorization || req.headers.Authorization || '';
    const user = await getUserFromToken(token);
    if (!user) return json(res, 401, { error: 'Unauthorized' });
    return json(res, 200, { user });
  }

  if (url.pathname === '/api/auth/users' && req.method === 'GET') {
    return json(res, 200, { users: await listUsers() });
  }

  // v1 auth aliases (Docker / legacy clients)
  if (url.pathname === '/v1/auth/register' && req.method === 'POST') {
    url.pathname = '/api/auth/register';
    return handleApi(req, res, url);
  }
  if (url.pathname === '/v1/auth/login' && req.method === 'POST') {
    url.pathname = '/api/auth/login';
    return handleApi(req, res, url);
  }
  if (url.pathname === '/v1/auth/me' && req.method === 'GET') {
    url.pathname = '/api/auth/me';
    return handleApi(req, res, url);
  }

  if (url.pathname === '/api/health' || url.pathname === '/health') {
    return json(res, 200, {
      status: 'ok',
      version: '1.0.0',
      platform: 'local',
      storage: isUsingMemoryStore() ? 'memory' : 'redis',
      timestamp: new Date().toISOString(),
    });
  }

  if (url.pathname === '/api/phone/actions') {
    return json(res, 200, {
      actions: PHONE_ACTIONS,
      directions: DIRECTIONS,
      direction_map: DIRECTION_MAP,
    });
  }

  if (url.pathname === '/api/phone/phones') {
    return json(res, 200, { phones: await listPhones() });
  }

  if (url.pathname === '/api/phone/logs') {
    return json(res, 200, { logs: await getLogs(80), storage: isUsingMemoryStore() ? 'memory' : 'redis' });
  }

  if (url.pathname === '/api/phone/poll' && req.method === 'GET') {
    const deviceId = url.searchParams.get('device_id');
    if (!deviceId) return json(res, 400, { error: 'device_id required' });
    await registerPhone(deviceId, url.searchParams.get('name') || 'MindTouch Phone');
    const command = await dequeueCommand(deviceId);
    if (command) return json(res, 200, { status: 'command', command });
    return json(res, 200, { status: 'idle' });
  }

  if (url.pathname === '/api/phone/register' && req.method === 'POST') {
    const body = await readBody(req);
    const deviceId = body.device_id || crypto.randomUUID();
    await registerPhone(deviceId, body.name || 'MindTouch Phone');
    return json(res, 200, { status: 'registered', device_id: deviceId });
  }

  if (url.pathname === '/api/phone/command' && req.method === 'POST') {
    const body = await readBody(req);
    const result = await sendCommand(body.action, body.device_id, body.text, 'admin');
    return json(res, result.status === 'error' ? 404 : 200, result);
  }

  if (url.pathname === '/api/phone/direction' && req.method === 'POST') {
    const body = await readBody(req);
    const action = DIRECTION_MAP[body.direction];
    if (!action) return json(res, 400, { error: `Unknown direction: ${body.direction}` });
    const result = await sendCommand(action, body.device_id, body.text, `ai:${body.direction}`);
    return json(res, result.status === 'error' ? 404 : 200, result);
  }

  if (url.pathname === '/api/phone/ack' && req.method === 'POST') {
    const body = await readBody(req);
    await addLog(`Phone ack: ${body.action || '?'} → ${body.status || 'unknown'}`, body.device_id);
    return json(res, 200, { status: 'ok' });
  }

  // v1 aliases for Flutter local docker mode
  const v1 = url.pathname.replace('/v1/phone', '/api/phone');
  if (v1 !== url.pathname) {
    url.pathname = v1;
    return handleApi(req, res, url);
  }

  json(res, 404, { error: 'Not found' });
}

function serveStatic(req, res, url) {
  let filePath = url.pathname === '/admin' || url.pathname === '/admin/'
    ? path.join(ROOT, 'public/admin/index.html')
    : path.join(ROOT, 'public', url.pathname);

  if (!fs.existsSync(filePath) || fs.statSync(filePath).isDirectory()) {
    res.writeHead(404);
    res.end('Not found');
    return;
  }
  const ext = path.extname(filePath);
  const types = { '.html': 'text/html', '.js': 'application/javascript', '.css': 'text/css' };
  res.writeHead(200, { 'Content-Type': types[ext] || 'application/octet-stream' });
  fs.createReadStream(filePath).pipe(res);
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://localhost:${PORT}`);
  if (url.pathname.startsWith('/api/') || url.pathname.startsWith('/v1/') || url.pathname === '/health') {
    return handleApi(req, res, url);
  }
  if (url.pathname === '/admin' || url.pathname.startsWith('/admin/') || url.pathname.startsWith('/public/')) {
    return serveStatic(req, res, url);
  }
  if (url.pathname === '/') {
    res.writeHead(302, { Location: '/admin' });
    res.end();
    return;
  }
  return handleApi(req, res, url);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`MindTouch live at http://localhost:${PORT}`);
  console.log(`Admin dashboard: http://localhost:${PORT}/admin`);
  console.log(`API health: http://localhost:${PORT}/api/health`);
  console.log(`Auth: POST /api/auth/register · POST /api/auth/login · GET /api/auth/me`);
});
