import crypto from 'crypto';
import { kvGetJson, kvSetJson } from './kv.js';

const USERS_KEY = 'auth:users';
const SESSIONS_KEY = 'auth:sessions';

function hashPassword(password) {
  return crypto.createHash('sha256').update(`mt:${password}`).digest('hex');
}

function newToken() {
  return crypto.randomBytes(24).toString('hex');
}

function normalizeBody(body = {}) {
  return {
    email: body.email,
    password: body.password,
    displayName: body.display_name || body.displayName || null,
    device: body.device || null,
  };
}

async function loadUsers() {
  return (await kvGetJson(USERS_KEY)) || {};
}

async function saveUsers(users) {
  await kvSetJson(USERS_KEY, users);
}

async function loadSessions() {
  return (await kvGetJson(SESSIONS_KEY)) || {};
}

async function saveSessions(sessions) {
  await kvSetJson(SESSIONS_KEY, sessions);
}

function attachDevice(user, device) {
  if (!device) return;
  user.devices = user.devices || [];
  const idx = user.devices.findIndex((d) => d.device_id === device.device_id);
  const entry = { ...device, last_seen: new Date().toISOString() };
  if (idx >= 0) user.devices[idx] = entry;
  else user.devices.push(entry);
}

export async function registerUser(body) {
  const { email, password, displayName, device } = normalizeBody(body);
  const key = (email || '').trim().toLowerCase();
  if (!key || !password || password.length < 6) {
    return { error: 'Email and password (6+ chars) required', status: 400 };
  }

  const users = await loadUsers();
  if (users[key]) {
    return { error: 'Account already exists', status: 409 };
  }

  const userId = crypto.randomUUID();
  const user = {
    user_id: userId,
    email: key,
    display_name: displayName || key.split('@')[0],
    password_hash: hashPassword(password),
    devices: [],
    created_at: new Date().toISOString(),
  };
  attachDevice(user, device);
  users[key] = user;

  const accessToken = newToken();
  const sessions = await loadSessions();
  sessions[accessToken] = { user_id: userId, email: key };

  await saveUsers(users);
  await saveSessions(sessions);

  return {
    status: 200,
    data: {
      access_token: accessToken,
      user_id: userId,
      email: key,
      display_name: user.display_name,
    },
  };
}

export async function loginUser(body) {
  const { email, password, device } = normalizeBody(body);
  const key = (email || '').trim().toLowerCase();
  const users = await loadUsers();
  const user = users[key];

  if (!user || user.password_hash !== hashPassword(password)) {
    return { error: 'Invalid email or password', status: 401 };
  }

  attachDevice(user, device);
  users[key] = user;

  const accessToken = newToken();
  const sessions = await loadSessions();
  sessions[accessToken] = { user_id: user.user_id, email: key };

  await saveUsers(users);
  await saveSessions(sessions);

  return {
    status: 200,
    data: {
      access_token: accessToken,
      user_id: user.user_id,
      email: key,
      display_name: user.display_name,
    },
  };
}

export async function getUserFromToken(token) {
  if (!token) return null;
  const clean = token.replace(/^Bearer\s+/i, '');
  const sessions = await loadSessions();
  const session = sessions[clean];
  if (!session) return null;

  const users = await loadUsers();
  const user = users[session.email];
  if (!user) return null;

  return {
    user_id: user.user_id,
    email: user.email,
    display_name: user.display_name,
    devices: user.devices || [],
    created_at: user.created_at,
  };
}

export async function validateToken(token) {
  if (!token) return null;
  const sessions = await loadSessions();
  return sessions[token.replace(/^Bearer\s+/i, '')] || null;
}

export async function listUsers() {
  const users = await loadUsers();
  return Object.values(users).map((u) => ({
    user_id: u.user_id,
    email: u.email,
    display_name: u.display_name,
    devices: u.devices?.length || 0,
    created_at: u.created_at,
  }));
}
