import { cors, handleOptions } from '../_lib/cors.js';
import { PHONE_ACTIONS, DIRECTIONS, DIRECTION_MAP } from '../_lib/actions.js';

export default function handler(req, res) {
  cors(res);
  if (handleOptions(req, res)) return;
  res.status(200).json({ actions: PHONE_ACTIONS, directions: DIRECTIONS, direction_map: DIRECTION_MAP });
}
