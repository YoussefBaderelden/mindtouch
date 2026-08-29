import { cors, handleOptions, readBody } from '../_lib/cors.js';
import { setTypingPreview, getTypingPreview } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;

  if (req.method === 'GET') {
    const deviceId = req.query.device_id;
    if (!deviceId) {
      res.status(400).json({ error: 'device_id required' });
      return;
    }
    const preview = await getTypingPreview(deviceId);
    res.status(200).json({ preview });
    return;
  }

  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }

  try {
    const body = await readBody(req);
    if (!body.device_id) {
      res.status(400).json({ error: 'device_id required' });
      return;
    }
    await setTypingPreview(body.device_id, body.preview ?? '');
    res.status(200).json({ status: 'ok' });
  } catch (e) {
    res.status(400).json({ error: String(e.message || e) });
  }
}
