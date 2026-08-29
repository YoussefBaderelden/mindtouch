import { cors, handleOptions } from '../_lib/cors.js';
import { getLogs, isUsingMemoryStore } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  const logs = await getLogs(80);
  res.status(200).json({
    logs,
    storage: isUsingMemoryStore() ? 'memory' : 'redis',
  });
}
