import { cors } from '../_lib/cors.js';
import { isUsingMemoryStore } from '../_lib/store.js';

export default function handler(req, res) {
  cors(res);
  res.status(200).json({
    status: 'ok',
    version: '1.0.0',
    platform: process.env.VERCEL ? 'vercel' : 'local',
    storage: isUsingMemoryStore() ? 'memory' : 'redis',
    timestamp: new Date().toISOString(),
  });
}
