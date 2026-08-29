import { cors } from '../_lib/cors.js';

export default function handler(req, res) {
  cors(res);
  res.status(200).json({
    status: 'ok',
    version: '1.0.0',
    platform: 'vercel',
    timestamp: new Date().toISOString(),
  });
}
