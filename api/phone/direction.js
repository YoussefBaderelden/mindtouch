import { cors, handleOptions, readBody } from '../_lib/cors.js';
import { DIRECTION_MAP } from '../_lib/actions.js';
import { sendCommand } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  try {
    const body = await readBody(req);
    const action = DIRECTION_MAP[body.direction];
    if (!action) {
      res.status(400).json({ error: `Unknown direction: ${body.direction}` });
      return;
    }
    const result = await sendCommand(
      action,
      body.device_id,
      body.text,
      `ai:${body.direction}`,
    );
    res.status(result.status === 'error' ? 404 : 200).json(result);
  } catch (e) {
    res.status(400).json({ error: String(e.message || e) });
  }
}
