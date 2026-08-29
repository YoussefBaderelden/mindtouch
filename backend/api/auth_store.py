"""Shared auth logic for FastAPI Docker backend."""

from __future__ import annotations

import hashlib
import json
import secrets
from datetime import datetime, timezone
from pathlib import Path
from uuid import uuid4

STORE_PATH = Path(__file__).resolve().parent.parent.parent / ".mindtouch-auth.json"

_users: dict[str, dict] = {}
_sessions: dict[str, dict] = {}


def _hash_password(password: str) -> str:
    return hashlib.sha256(f"mt:{password}".encode()).hexdigest()


def _load_store() -> None:
    global _users, _sessions
    if not STORE_PATH.exists():
        return
    try:
        data = json.loads(STORE_PATH.read_text(encoding="utf-8"))
        _users = data.get("users", {})
        _sessions = data.get("sessions", {})
    except OSError:
        pass


def _save_store() -> None:
    STORE_PATH.write_text(
        json.dumps({"users": _users, "sessions": _sessions}, indent=2),
        encoding="utf-8",
    )


def _attach_device(user: dict, device: dict | None) -> None:
    if not device:
        return
    devices = user.setdefault("devices", [])
    device_id = device.get("device_id")
    entry = {**device, "last_seen": datetime.now(timezone.utc).isoformat()}
    for idx, existing in enumerate(devices):
        if existing.get("device_id") == device_id:
            devices[idx] = entry
            return
    devices.append(entry)


_load_store()


def register_user(body: dict) -> tuple[dict | None, dict | None]:
    email = (body.get("email") or "").strip().lower()
    password = body.get("password") or ""
    display_name = body.get("display_name") or body.get("displayName")
    device = body.get("device")

    if not email or len(password) < 6:
        return None, {"error": "Email and password (6+ chars) required", "status": 400}
    if email in _users:
        return None, {"error": "Account already exists", "status": 409}

    user_id = str(uuid4())
    user = {
        "user_id": user_id,
        "email": email,
        "display_name": display_name or email.split("@")[0],
        "password_hash": _hash_password(password),
        "devices": [],
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    _attach_device(user, device)
    _users[email] = user

    token = secrets.token_hex(24)
    _sessions[token] = {"user_id": user_id, "email": email}
    _save_store()

    return {
        "access_token": token,
        "user_id": user_id,
        "email": email,
        "display_name": user["display_name"],
    }, None


def login_user(body: dict) -> tuple[dict | None, dict | None]:
    email = (body.get("email") or "").strip().lower()
    password = body.get("password") or ""
    device = body.get("device")
    user = _users.get(email)

    if not user or user["password_hash"] != _hash_password(password):
        return None, {"error": "Invalid email or password", "status": 401}

    _attach_device(user, device)
    _users[email] = user

    token = secrets.token_hex(24)
    _sessions[token] = {"user_id": user["user_id"], "email": email}
    _save_store()

    return {
        "access_token": token,
        "user_id": user["user_id"],
        "email": email,
        "display_name": user["display_name"],
    }, None


def get_user_from_token(authorization: str | None) -> dict | None:
    if not authorization:
        return None
    token = authorization.replace("Bearer ", "").strip()
    session = _sessions.get(token)
    if not session:
        return None
    user = _users.get(session["email"])
    if not user:
        return None
    return {
        "user_id": user["user_id"],
        "email": user["email"],
        "display_name": user["display_name"],
        "devices": user.get("devices", []),
        "created_at": user.get("created_at"),
    }
