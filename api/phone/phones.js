import { cors, handleOptions } from '../_lib/cors.js';
import { listPhones } from '../_lib/store.js';

export default async function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  const phones = await listPhones();
  res.status(200).json({ phones });
}
