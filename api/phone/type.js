import { cors, handleOptions, readBody } from '../_lib/cors.js';
import { sendCommand, setTypingPreview } from '../_lib/store.js';

/** Type a full message live — keyboard shown, chars appear one by one on phone. */
export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  try {
    const body = await readBody(req);
    const text = String(body.text ?? '');
    if (!text.trim()) {
      res.status(400).json({ error: 'text required' });
      return;
    }
    await setTypingPreview(body.device_id, '');
    const focus = await sendCommand('show_keyboard', body.device_id, null, 'chat:focus');
    if (focus.status === 'error') {
      res.status(404).json(focus);
      return;
    }
    const result = await sendCommand('type_message', body.device_id, text, 'chat:type');
    res.status(result.status === 'error' ? 404 : 200).json({ ...result, text_length: text.length });
  } catch (e) {
    res.status(400).json({ error: String(e.message || e) });
  }
}
