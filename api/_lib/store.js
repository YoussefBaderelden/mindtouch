import { Redis } from '@upstash/redis';

/** @type {Map<string, unknown> | null} */
let memoryStore = null;

function getMemoryStore() {
  if (!memoryStore) memoryStore = new Map();
  return memoryStore;
}

function getRedis() {
  const url = process.env.UPSTASH_REDIS_REST_URL || process.env.KV_REST_API_URL;
  const token = process.env.UPSTASH_REDIS_REST_TOKEN || process.env.KV_REST_API_TOKEN;
  if (!url || !token) return null;
  return new Redis({ url, token });
}

const redis = getRedis();
const useMemory = !redis;

if (useMemory) {
  console.warn('[MindTouch] No Redis configured — using in-memory store (dev only). Add Upstash on Vercel for production.');
}

async function memGet(key) {
  return getMemoryStore().get(key) ?? null;
}

async function memSet(key, value, _opts) {
  getMemoryStore().set(key, value);
}

async function memLpush(key, value) {
  const store = getMemoryStore();
  const list = store.get(key) || [];
  list.unshift(value);
  if (list.length > 100) list.length = 100;
  store.set(key, list);
  return list.length;
}

async function memRpop(key) {
  const store = getMemoryStore();
  const list = store.get(key) || [];
  const item = list.pop() ?? null;
  store.set(key, list);
  return item;
}

async function memLrange(key, start, stop) {
  const list = getMemoryStore().get(key) || [];
  return list.slice(start, stop + 1);
}

async function memSadd(key, member) {
  const store = getMemoryStore();
  const set = new Set(store.get(key) || []);
  set.add(member);
  store.set(key, [...set]);
}

async function memSmembers(key) {
  return getMemoryStore().get(key) || [];
}

export async function registerPhone(deviceId, name) {
  const payload = JSON.stringify({ device_id: deviceId, name, last_seen: Date.now() });
  if (useMemory) {
    await memSet(`phone:${deviceId}`, payload);
    await memSadd('phones', deviceId);
    return;
  }
  await redis.set(`phone:${deviceId}`, payload, { ex: 86400 });
  await redis.sadd('phones', deviceId);
}

export async function listPhones() {
  let ids = [];
  if (useMemory) {
    ids = await memSmembers('phones');
  } else {
    ids = await redis.smembers('phones');
  }
  const phones = [];
  for (const id of ids) {
    const raw = useMemory
      ? await memGet(`phone:${id}`)
      : await redis.get(`phone:${id}`);
    if (raw) {
      phones.push(typeof raw === 'string' ? JSON.parse(raw) : raw);
    }
  }
  return phones.map((p) => ({
    device_id: p.device_id,
    name: p.name || `Phone ${String(p.device_id).slice(0, 8)}`,
  }));
}

export async function enqueueCommand(deviceId, command) {
  const payload = JSON.stringify(command);
  const key = `queue:${deviceId}`;
  if (useMemory) {
    await memLpush(key, payload);
  } else {
    await redis.lpush(key, payload);
    await redis.ltrim(key, 0, 49);
  }
}

export async function dequeueCommand(deviceId) {
  const key = `queue:${deviceId}`;
  const raw = useMemory ? await memRpop(key) : await redis.rpop(key);
  if (!raw) return null;
  return typeof raw === 'string' ? JSON.parse(raw) : raw;
}

export async function addLog(message, deviceId = null) {
  const entry = JSON.stringify({
    time: new Date().toISOString(),
    message,
    device_id: deviceId,
  });
  if (useMemory) {
    await memLpush('logs', entry);
  } else {
    await redis.lpush('logs', entry);
    await redis.ltrim('logs', 0, 199);
  }
}

export async function getLogs(limit = 50) {
  const raw = useMemory
    ? await memLrange('logs', 0, limit - 1)
    : await redis.lrange('logs', 0, limit - 1);
  return raw.map((item) => (typeof item === 'string' ? JSON.parse(item) : item));
}

export async function pickTargetDevice(deviceId) {
  if (deviceId) return deviceId;
  const phones = await listPhones();
  return phones[0]?.device_id ?? null;
}

export async function sendCommand(action, deviceId, text, source = 'admin') {
  const target = await pickTargetDevice(deviceId);
  if (!target) {
    return { status: 'error', message: 'No phone connected. Open MindTouch app on Android.' };
  }
  const commandId = crypto.randomUUID();
  const command = {
    type: 'execute',
    command_id: commandId,
    action,
    text: text || null,
  };
  await enqueueCommand(target, command);
  await addLog(`[${source}] → ${action}${text ? ` "${text}"` : ''}`, target);
  return { status: 'sent', command_id: commandId, device_id: target, action };
}

export function isUsingMemoryStore() {
  return useMemory;
}
