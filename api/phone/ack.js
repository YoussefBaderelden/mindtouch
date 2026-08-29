import { cors, handleOptions, readBody } from '../_lib/cors.js';
import { addLog } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  try {
    const body = await readBody(req);
    await addLog(
      `Phone ack: ${body.action || '?'} → ${body.status || 'unknown'}`,
      body.device_id,
    );
    res.status(200).json({ status: 'ok' });
  } catch (e) {
    res.status(400).json({ error: String(e.message || e) });
  }
}
