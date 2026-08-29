# MindTouch

Intelligent BCI Cap for Assistive Smartphone Control — Flutter client (Android + Windows) and containerized backend.

## Design System — Neural Luxe

| Token | Value | Usage |
|-------|-------|-------|
| Void | `#050810` | Background |
| Primary | `#00F5D4` | Neural accent, selection glow |
| Secondary | `#9B5DE5` | Gradient partner |
| Confirm | `#FFD166` | Confirm actions |
| Danger | `#FF4757` | SOS / emergency |
| Display font | **Syne** | Headlines |
| Body font | **Manrope** | UI copy |

## Project Structure

```
mindtouch/
├── apps/client/          Flutter app (Android + Windows)
├── backend/api/          FastAPI unified backend
└── infra/                Docker Compose (Postgres, Timescale, Redis, API)
```

## Quick Start — Flutter App

```bash
cd apps/client
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows   # or android device/emulator
```

## Deploy to Vercel (recommended for testing)

See **[DEPLOY.md](DEPLOY.md)** for full steps.

1. Push repo to GitHub
2. Import at [vercel.com/new](https://vercel.com/new)
3. Add **Upstash Redis** storage in Vercel dashboard
4. Run app: `flutter run --dart-define=MINDTOUCH_API=https://YOUR-PROJECT.vercel.app`
5. Open `https://YOUR-PROJECT.vercel.app/admin` to control phone

## Quick Start — Backend (local Docker, optional)

```bash
cd infra
docker compose up -d
curl http://localhost:8080/health
```

**Admin Dashboard:** open [http://localhost:8080/admin](http://localhost:8080/admin)

## Phone Control (Android)

MindTouch controls **everything on your phone** via Android Accessibility Service:

| AI Direction | Phone Action |
|-------------|--------------|
| Up | Scroll up |
| Down | Scroll down |
| Left | Swipe left |
| Right | Swipe right |
| Confirm | Tap center |
| Cancel | Back |

**Setup:**
1. Install app on Android phone/emulator
2. Open **Setup** tab → **Enable Accessibility** → turn on "MindTouch Control"
3. Start backend (`docker compose up`)
4. Open admin dashboard at `http://YOUR_PC_IP:8080/admin`
5. Phone auto-connects via WebSocket — send any action from admin

**Emulator backend URL:** `ws://10.0.2.2:8080` (built-in)  
**Physical device:** edit `remote_control_service.dart` → set your PC's LAN IP

### All Phone Actions

Scroll, swipe, tap, back, home, recents, type text, send, delete, paste, focus chat — all available in:
- App matrix (Phone surface)
- Admin dashboard (every button)
- AI direction mapping (direct mode)

## Features (Phase 0 Scaffold)

- **Neural Luxe** dark theme with animated mesh background
- **Matrix control UI** — large glow cells, surface switcher (Phone / PC / Smart Home / Safety)
- **Onboarding flow** — welcome → permissions → calibration → ready
- **Simulated BCI input** — direction strip for demo until hardware connects
- **Drift SQLite** — calibration, devices, caregivers, reminders, session logs
- **FastAPI backend** — auth, devices, AI WebSocket mock, SOS, smart home stubs
- **Docker infra** — PostgreSQL + TimescaleDB + Redis

## Roadmap

| Phase | Scope |
|-------|-------|
| 0 | Scaffold (this repo) |
| 1 | BLE, FGS, Accessibility Service, real AI client |
| 2 | Windows companion, Home Assistant integration |
| 3 | Medical MVP — SOS + reminders + caregiver view |
| 4 | Performance hardening + security review |

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/health` | Health check |
| POST | `/v1/auth/register` | User registration |
| POST | `/v1/auth/login` | Login |
| GET | `/v1/devices` | List paired devices |
| WS | `/v1/ai/stream` | AI inference stream |
| WS | `/v1/phone/control` | Phone + admin control hub |
| GET | `/admin` | Web admin dashboard |
| GET | `/v1/phone/actions` | List all phone actions |
| POST | `/v1/phone/command` | Send phone command |
| POST | `/v1/phone/direction` | Send AI direction |
| POST | `/v1/sos/trigger` | Emergency SOS |
| GET | `/v1/smart-home/entities` | HA entities |
| POST | `/v1/smart-home/execute` | Execute device action |
