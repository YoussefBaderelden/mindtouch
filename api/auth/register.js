import { cors, readBody } from '../_lib/cors.js';
import { registerUser } from '../_lib/auth.js';

export default async function handler(req, res) {
  cors(res);
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Method not allowed' });
    return;
  }
  const body = await readBody(req);
  const result = await registerUser(body);
  if (result.error) {
    res.status(result.status).json({ error: result.error });
    return;
  }
  res.status(200).json(result.data);
}
