import { cors, handleOptions, readBody } from '../_lib/cors.js';
import { registerPhone } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  try {
    const body = await readBody(req);
    const deviceId = body.device_id || crypto.randomUUID();
    const name = body.name || 'MindTouch Phone';
    await registerPhone(deviceId, name);
    res.status(200).json({ status: 'registered', device_id: deviceId, name });
  } catch (e) {
    res.status(400).json({ error: String(e.message || e) });
  }
}
