"""MindTouch API — unified backend gateway for v1."""

from contextlib import asynccontextmanager
from datetime import datetime, timezone
import json
import random
from pathlib import Path
from typing import Literal
from uuid import uuid4

from fastapi import FastAPI, Header, HTTPException, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel, EmailStr, Field

from phone_control import DIRECTIONS, router as phone_router
from auth_store import get_user_from_token, login_user, register_user

STATIC_DIR = Path(__file__).parent / "static"


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield


app = FastAPI(
    title="MindTouch API",
    description="Backend for BCI assistive control — auth, AI, devices, smart home, medical, phone control",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(phone_router)

if STATIC_DIR.exists():
    app.mount("/static", StaticFiles(directory=str(STATIC_DIR)), name="static")


# ── Models ──────────────────────────────────────────────────────────────────

class HealthResponse(BaseModel):
    status: str
    version: str
    timestamp: str


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=6)
    display_name: str | None = None
    device: dict | None = None


class LoginRequest(BaseModel):
    email: EmailStr
    password: str
    device: dict | None = None


class AuthResponse(BaseModel):
    access_token: str
    user_id: str
    email: str
    display_name: str


class DeviceRegisterRequest(BaseModel):
    type: Literal["cap", "phone", "pc", "smart_home"]
    platform: str | None = None
    name: str


class InferenceResult(BaseModel):
    direction: str
    confidence: float
    latency_ms: int


class SosTriggerRequest(BaseModel):
    lat: float | None = None
    lng: float | None = None


class SosResponse(BaseModel):
    id: str
    status: str
    message: str


class SmartHomeExecuteRequest(BaseModel):
    entity_id: str
    action: str
    value: float | None = None


class SessionSummaryRequest(BaseModel):
    duration_sec: int
    intent_count: int
    avg_latency_ms: int
    signal_quality_avg: float


# ── Routes ──────────────────────────────────────────────────────────────────

@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(
        status="ok",
        version="1.0.0",
        timestamp=datetime.now(timezone.utc).isoformat(),
    )


@app.get("/admin")
async def admin_dashboard():
    admin_file = STATIC_DIR / "admin" / "index.html"
    if admin_file.exists():
        return FileResponse(admin_file)
    return {"message": "Admin dashboard not found. Build static/admin/index.html"}


@app.post("/v1/auth/register", response_model=AuthResponse)
@app.post("/api/auth/register", response_model=AuthResponse)
async def register(body: RegisterRequest):
    data, err = register_user(body.model_dump())
    if err:
        raise HTTPException(status_code=err["status"], detail=err["error"])
    return AuthResponse(**data)


@app.post("/v1/auth/login", response_model=AuthResponse)
@app.post("/api/auth/login", response_model=AuthResponse)
async def login(body: LoginRequest):
    data, err = login_user(body.model_dump())
    if err:
        raise HTTPException(status_code=err["status"], detail=err["error"])
    return AuthResponse(**data)


@app.get("/api/auth/me")
@app.get("/v1/auth/me")
async def auth_me(authorization: str | None = Header(default=None)):
    user = get_user_from_token(authorization)
    if not user:
        raise HTTPException(status_code=401, detail="Unauthorized")
    return {"user": user}


@app.get("/v1/devices")
async def list_devices():
    return {
        "devices": [
            {"id": "cap-0042", "type": "cap", "name": "MindTouch Cap", "last_seen": "2026-08-29T18:00:00Z"},
            {"id": "pc-win-01", "type": "pc", "name": "Living Room PC", "platform": "windows"},
        ]
    }


@app.post("/v1/devices/register")
async def register_device(body: DeviceRegisterRequest):
    return {"id": str(uuid4()), "type": body.type, "name": body.name, "status": "registered"}


@app.post("/v1/sos/trigger", response_model=SosResponse)
async def trigger_sos(body: SosTriggerRequest):
    sos_id = str(uuid4())
    return SosResponse(
        id=sos_id,
        status="triggered",
        message="Caregivers notified via push + SMS fallback",
    )


@app.get("/v1/smart-home/entities")
async def list_entities():
    return {
        "entities": [
            {"id": "light.living_room", "name": "Living Room Light", "room": "Living Room", "type": "light"},
            {"id": "climate.bedroom", "name": "Bedroom Thermostat", "room": "Bedroom", "type": "climate"},
            {"id": "switch.kitchen_plug", "name": "Kitchen Plug", "room": "Kitchen", "type": "switch"},
        ]
    }


@app.post("/v1/smart-home/execute")
async def execute_smart_home(body: SmartHomeExecuteRequest):
    return {"status": "ok", "entity_id": body.entity_id, "action": body.action}


@app.post("/v1/sessions/summary")
async def post_session_summary(body: SessionSummaryRequest):
    return {"status": "stored", "id": str(uuid4())}


@app.websocket("/v1/ai/stream")
async def ai_stream(websocket: WebSocket):
    """Mock AI inference WebSocket — returns direction + confidence."""
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_text()
            _ = json.loads(data) if data.startswith("{") else data
            direction = random.choice(DIRECTIONS)
            confidence = round(random.uniform(0.72, 0.98), 3)
            result = InferenceResult(
                direction=direction,
                confidence=confidence,
                latency_ms=random.randint(180, 420),
            )
            await websocket.send_json(result.model_dump())
    except WebSocketDisconnect:
        pass
