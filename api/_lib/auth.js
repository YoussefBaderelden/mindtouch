import crypto from 'crypto';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const STORE_PATH = path.join(__dirname, '..', '..', '.mindtouch-auth.json');

/** @type {Map<string, object>} */
const users = new Map();
/** @type {Map<string, object>} */
const sessions = new Map();

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

function loadStore() {
  try {
    if (!fs.existsSync(STORE_PATH)) return;
    const raw = JSON.parse(fs.readFileSync(STORE_PATH, 'utf8'));
    for (const [key, value] of Object.entries(raw.users || {})) {
      users.set(key, value);
    }
    for (const [key, value] of Object.entries(raw.sessions || {})) {
      sessions.set(key, value);
    }
    console.log(`[MindTouch Auth] Loaded ${users.size} users from disk`);
  } catch (err) {
    console.warn('[MindTouch Auth] Could not load store:', err.message);
  }
}

function saveStore() {
  try {
    fs.writeFileSync(
      STORE_PATH,
      JSON.stringify(
        {
          users: Object.fromEntries(users),
          sessions: Object.fromEntries(sessions),
        },
        null,
        2,
      ),
    );
  } catch (err) {
    console.warn('[MindTouch Auth] Could not save store:', err.message);
  }
}

function attachDevice(user, device) {
  if (!device) return;
  user.devices = user.devices || [];
  const idx = user.devices.findIndex((d) => d.device_id === device.device_id);
  const entry = { ...device, last_seen: new Date().toISOString() };
  if (idx >= 0) user.devices[idx] = entry;
  else user.devices.push(entry);
}

loadStore();

export function registerUser(body) {
  const { email, password, displayName, device } = normalizeBody(body);
  const key = (email || '').trim().toLowerCase();
  if (!key || !password || password.length < 6) {
    return { error: 'Email and password (6+ chars) required', status: 400 };
  }
  if (users.has(key)) {
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
  users.set(key, user);

  const accessToken = newToken();
  sessions.set(accessToken, { user_id: userId, email: key });
  saveStore();

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

export function loginUser(body) {
  const { email, password, device } = normalizeBody(body);
  const key = (email || '').trim().toLowerCase();
  const user = users.get(key);
  if (!user || user.password_hash !== hashPassword(password)) {
    return { error: 'Invalid email or password', status: 401 };
  }

  attachDevice(user, device);
  users.set(key, user);

  const accessToken = newToken();
  sessions.set(accessToken, { user_id: user.user_id, email: key });
  saveStore();

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

export function getUserFromToken(token) {
  if (!token) return null;
  const session = sessions.get(token.replace(/^Bearer\s+/i, ''));
  if (!session) return null;
  const user = users.get(session.email);
  if (!user) return null;
  return {
    user_id: user.user_id,
    email: user.email,
    display_name: user.display_name,
    devices: user.devices || [],
    created_at: user.created_at,
  };
}

export function validateToken(token) {
  if (!token) return null;
  return sessions.get(token.replace(/^Bearer\s+/i, '')) || null;
}

export function listUsers() {
  return [...users.values()].map((u) => ({
    user_id: u.user_id,
    email: u.email,
    display_name: u.display_name,
    devices: u.devices?.length || 0,
    created_at: u.created_at,
  }));
}
