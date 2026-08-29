"""Phone control hub — connects admin dashboard to phone clients via WebSocket."""

from __future__ import annotations

import asyncio
import json
from datetime import datetime, timezone
from typing import Any
from uuid import uuid4

from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from pydantic import BaseModel, Field

router = APIRouter(prefix="/v1/phone", tags=["phone"])

# ── Action catalog (mirrors Flutter PhoneAction) ────────────────────────────

PHONE_ACTIONS: list[dict[str, str]] = [
    {"id": "tap_center", "label": "Tap Center", "category": "Tap", "description": "Tap screen center"},
    {"id": "tap_top", "label": "Tap Top", "category": "Tap", "description": "Tap upper area"},
    {"id": "tap_bottom", "label": "Tap Bottom", "category": "Tap", "description": "Tap lower area"},
    {"id": "tap_left", "label": "Tap Left", "category": "Tap", "description": "Tap left side"},
    {"id": "tap_right", "label": "Tap Right", "category": "Tap", "description": "Tap right side"},
    {"id": "double_tap", "label": "Double Tap", "category": "Tap", "description": "Double tap center"},
    {"id": "long_press", "label": "Long Press", "category": "Tap", "description": "Long press center"},
    {"id": "scroll_up", "label": "Scroll Up", "category": "Scroll & Swipe", "description": "Scroll up"},
    {"id": "scroll_down", "label": "Scroll Down", "category": "Scroll & Swipe", "description": "Scroll down"},
    {"id": "scroll_left", "label": "Scroll Left", "category": "Scroll & Swipe", "description": "Scroll left"},
    {"id": "scroll_right", "label": "Scroll Right", "category": "Scroll & Swipe", "description": "Scroll right"},
    {"id": "swipe_up", "label": "Swipe Up", "category": "Scroll & Swipe", "description": "Swipe up"},
    {"id": "swipe_down", "label": "Swipe Down", "category": "Scroll & Swipe", "description": "Swipe down"},
    {"id": "swipe_left", "label": "Swipe Left", "category": "Scroll & Swipe", "description": "Swipe left"},
    {"id": "swipe_right", "label": "Swipe Right", "category": "Scroll & Swipe", "description": "Swipe right"},
    {"id": "back", "label": "Back", "category": "Navigation", "description": "Android back"},
    {"id": "home", "label": "Home", "category": "Navigation", "description": "Home screen"},
    {"id": "recents", "label": "Recents", "category": "Navigation", "description": "App switcher"},
    {"id": "notifications", "label": "Notifications", "category": "Navigation", "description": "Notification shade"},
    {"id": "quick_settings", "label": "Quick Settings", "category": "Navigation", "description": "Quick settings"},
    {"id": "type_text", "label": "Type Text", "category": "Chat & Text", "description": "Type into focused field"},
    {"id": "delete", "label": "Delete", "category": "Chat & Text", "description": "Delete character"},
    {"id": "enter", "label": "Enter / Send", "category": "Chat & Text", "description": "Send message"},
    {"id": "paste", "label": "Paste", "category": "Chat & Text", "description": "Paste clipboard"},
    {"id": "select_all", "label": "Select All", "category": "Chat & Text", "description": "Select all text"},
    {"id": "focus_search", "label": "Focus Chat", "category": "Chat & Text", "description": "Focus search/chat input"},
]

DIRECTION_MAP = {
    "up": "scroll_up",
    "down": "scroll_down",
    "left": "swipe_left",
    "right": "swipe_right",
    "confirm": "tap_center",
    "cancel": "back",
}

DIRECTIONS = list(DIRECTION_MAP.keys())


class CommandRequest(BaseModel):
    action: str
    device_id: str | None = None
    text: str | None = None


class DirectionRequest(BaseModel):
    direction: str
    device_id: str | None = None
    text: str | None = None


class RegisterRequest(BaseModel):
    device_id: str | None = None
    name: str = "MindTouch Phone"


class AckRequest(BaseModel):
    device_id: str | None = None
    command_id: str | None = None
    status: str = "ok"
    action: str | None = None


class PhoneConnectionManager:
    def __init__(self) -> None:
        self.phones: dict[str, WebSocket] = {}
        self.admins: set[WebSocket] = set()
        self.logs: list[dict[str, Any]] = []
        self._last_command_at: dict[str, float] = {}
        self._min_command_gap_sec = 0.15
        # HTTP poll fallback (same as Vercel)
        self._poll_phones: dict[str, dict[str, Any]] = {}
        self._command_queues: dict[str, list[dict[str, Any]]] = {}

    async def register_phone(self, device_id: str, ws: WebSocket, name: str) -> None:
        self.phones[device_id] = ws
        await self._broadcast_admins({
            "type": "phones_updated",
            "phones": self.list_phones(),
        })
        await self._log(f"Phone connected: {name} ({device_id[:8]}…)", device_id)

    def unregister_phone(self, device_id: str) -> None:
        self.phones.pop(device_id, None)

    async def register_admin(self, ws: WebSocket) -> None:
        self.admins.add(ws)
        await ws.send_json({
            "type": "phones_updated",
            "phones": self.list_phones(),
        })
        await ws.send_json({
            "type": "log_history",
            "logs": self.logs[-100:],
        })

    def unregister_admin(self, ws: WebSocket) -> None:
        self.admins.discard(ws)

    def list_phones(self) -> list[dict[str, str]]:
        ws_phones = [{"device_id": did, "name": f"Phone {did[:8]}"} for did in self.phones]
        poll_phones = [
            {"device_id": did, "name": p.get("name", f"Phone {did[:8]}")}
            for did, p in self._poll_phones.items()
        ]
        merged = {p["device_id"]: p for p in ws_phones + poll_phones}
        return list(merged.values())

    def register_poll_phone(self, device_id: str, name: str) -> None:
        self._poll_phones[device_id] = {"device_id": device_id, "name": name, "last_seen": datetime.now(timezone.utc).isoformat()}
        if device_id not in self._command_queues:
            self._command_queues[device_id] = []

    def dequeue_poll_command(self, device_id: str) -> dict[str, Any] | None:
        queue = self._command_queues.get(device_id, [])
        if not queue:
            return None
        return queue.pop(0)

    async def enqueue_poll_command(self, device_id: str, command: dict[str, Any]) -> None:
        if device_id not in self._command_queues:
            self._command_queues[device_id] = []
        self._command_queues[device_id].append(command)
        if len(self._command_queues[device_id]) > 50:
            self._command_queues[device_id] = self._command_queues[device_id][-50:]

    async def send_command(
        self,
        action: str,
        device_id: str | None = None,
        text: str | None = None,
        source: str = "admin",
    ) -> dict[str, Any]:
        import time

        command_id = str(uuid4())
        target = device_id or (next(iter(self.phones)) if self.phones else None)
        if not target:
            poll_ids = list(self._poll_phones.keys())
            target = poll_ids[0] if poll_ids else None
        if not target:
            return {"status": "error", "message": "No phone connected. Open MindTouch app on Android."}

        payload = {
            "type": "execute",
            "command_id": command_id,
            "action": action,
            "text": text,
        }

        if target in self.phones:
            now = time.time()
            last = self._last_command_at.get(target, 0)
            if now - last < self._min_command_gap_sec:
                await asyncio.sleep(self._min_command_gap_sec - (now - last))
            self._last_command_at[target] = time.time()
            try:
                await self.phones[target].send_json(payload)
            except Exception:
                self.unregister_phone(target)
                return {"status": "error", "message": "Phone disconnected"}
        else:
            await self.enqueue_poll_command(target, payload)

        await self._log(f"[{source}] → {action}" + (f' "{text}"' if text else ""), target)
        return {"status": "sent", "command_id": command_id, "device_id": target, "action": action}

    async def handle_ack(self, data: dict[str, Any]) -> None:
        status = data.get("status", "unknown")
        action = data.get("action", "?")
        await self._log(f"Phone ack: {action} → {status}")

    async def _log(self, message: str, device_id: str | None = None) -> None:
        entry = {
            "time": datetime.now(timezone.utc).isoformat(),
            "message": message,
            "device_id": device_id,
        }
        self.logs.append(entry)
        if len(self.logs) > 500:
            self.logs = self.logs[-500:]
        await self._broadcast_admins({"type": "log", **entry})

    async def _broadcast_admins(self, payload: dict[str, Any]) -> None:
        dead: list[WebSocket] = []
        for admin in self.admins:
            try:
                await admin.send_json(payload)
            except Exception:
                dead.append(admin)
        for ws in dead:
            self.admins.discard(ws)


hub = PhoneConnectionManager()


@router.get("/actions")
async def list_actions():
    return {"actions": PHONE_ACTIONS, "directions": DIRECTIONS, "direction_map": DIRECTION_MAP}


@router.get("/phones")
async def list_phones():
    return {"phones": hub.list_phones()}


@router.post("/command")
async def send_command(body: CommandRequest):
    return await hub.send_command(body.action, body.device_id, body.text)


@router.post("/direction")
async def send_direction(body: DirectionRequest):
    action = DIRECTION_MAP.get(body.direction)
    if not action:
        return {"status": "error", "message": f"Unknown direction: {body.direction}"}
    return await hub.send_command(action, body.device_id, body.text, source=f"ai:{body.direction}")


@router.post("/register")
async def register_phone_http(body: RegisterRequest):
    device_id = body.device_id or str(uuid4())
    hub.register_poll_phone(device_id, body.name)
    return {"status": "registered", "device_id": device_id, "name": body.name}


@router.get("/poll")
async def poll_commands(device_id: str, name: str = "MindTouch Phone"):
    hub.register_poll_phone(device_id, name)
    command = hub.dequeue_poll_command(device_id)
    if command:
        return {"status": "command", "command": command}
    return {"status": "idle"}


@router.post("/ack")
async def ack_command(body: AckRequest):
    await hub.handle_ack(body.model_dump())
    return {"status": "ok"}


@router.get("/logs")
async def get_logs():
    return {"logs": hub.logs[-80:]}


@router.websocket("/control")
async def phone_control_ws(websocket: WebSocket):
    await websocket.accept()
    role: str | None = None
    device_id: str | None = None

    try:
        while True:
            raw = await websocket.receive_text()
            data = json.loads(raw)
            msg_type = data.get("type")

            if msg_type == "register":
                role = data.get("role")
                if role == "phone":
                    device_id = data.get("device_id") or str(uuid4())
                    await hub.register_phone(device_id, websocket, data.get("name", "Phone"))
                elif role == "admin":
                    await hub.register_admin(websocket)
                continue

            if msg_type == "command" and role == "admin":
                await hub.send_command(
                    data.get("action", ""),
                    data.get("device_id"),
                    data.get("text"),
                )
                continue

            if msg_type == "direction" and role == "admin":
                action = DIRECTION_MAP.get(data.get("direction", ""), "")
                if action:
                    await hub.send_command(
                        action,
                        data.get("device_id"),
                        data.get("text"),
                        source=f"ai:{data.get('direction')}",
                    )
                continue

            if msg_type == "ack" and role == "phone":
                await hub.handle_ack(data)

    except WebSocketDisconnect:
        pass
    finally:
        if role == "phone" and device_id:
            hub.unregister_phone(device_id)
            await hub._broadcast_admins({"type": "phones_updated", "phones": hub.list_phones()})
        elif role == "admin":
            hub.unregister_admin(websocket)
