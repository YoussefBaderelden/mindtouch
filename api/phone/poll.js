import { cors, handleOptions } from '../_lib/cors.js';
import { dequeueCommand, registerPhone } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  const deviceId = req.query.device_id;
  if (!deviceId) {
    res.status(400).json({ error: 'device_id required' });
    return;
  }
  await registerPhone(deviceId, req.query.name || 'MindTouch Phone');
  const command = await dequeueCommand(deviceId);
  if (command) {
    res.status(200).json({ status: 'command', command });
  } else {
    res.status(200).json({ status: 'idle' });
  }
}
