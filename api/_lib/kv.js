import { Redis } from '@upstash/redis';

/** @type {Map<string, unknown> | null} */
let memoryStore = null;

export function getRedis() {
  const url = process.env.UPSTASH_REDIS_REST_URL || process.env.KV_REST_API_URL;
  const token = process.env.UPSTASH_REDIS_REST_TOKEN || process.env.KV_REST_API_TOKEN;
  if (!url || !token) return null;
  return new Redis({ url, token });
}

export const redis = getRedis();
export const useMemory = !redis;

function getMemoryStore() {
  if (!memoryStore) memoryStore = new Map();
  return memoryStore;
}

export async function kvGet(key) {
  if (useMemory) return getMemoryStore().get(key) ?? null;
  return redis.get(key);
}

export async function kvSet(key, value) {
  if (useMemory) {
    getMemoryStore().set(key, value);
    return;
  }
  await redis.set(key, value);
}

export async function kvGetJson(key) {
  const raw = await kvGet(key);
  if (!raw) return null;
  return typeof raw === 'string' ? JSON.parse(raw) : raw;
}

export async function kvSetJson(key, value) {
  await kvSet(key, JSON.stringify(value));
}

export function isUsingMemoryStore() {
  return useMemory;
}

if (useMemory && process.env.VERCEL) {
  console.warn('[MindTouch] Running on Vercel without Redis — data will not persist between requests. Add Upstash Redis in Vercel Storage.');
}
