# MindTouch — Deploy to Vercel

Everything (admin dashboard + cloud API) runs on **Vercel**. The Android app polls the API — no WebSockets needed.

## 1. Push to GitHub

```bash
cd "e:\flutter in AS\mindtouch"
git init
git add .
git commit -m "MindTouch cloud deploy"
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

## 2. Deploy on Vercel

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your GitHub repo
3. **Root directory:** leave as `.` (project root)
4. **Framework:** Other (static + serverless)
5. Click **Deploy**

Your URLs will be:
- **Admin:** `https://YOUR-PROJECT.vercel.app/admin`
- **API health:** `https://YOUR-PROJECT.vercel.app/api/health`

## 3. Add Redis (required for production)

Without Redis, commands may not reach the phone (serverless is stateless).

1. Vercel project → **Storage** → **Create Upstash Redis**
2. Connect to project (auto-adds env vars)

Or manually set:
- `UPSTASH_REDIS_REST_URL`
- `UPSTASH_REDIS_REST_TOKEN`

Redeploy after adding storage.

## 4. Run the Android app

Point the app at your Vercel URL:

```bash
cd apps/client
flutter run --dart-define=MINDTOUCH_API=https://YOUR-PROJECT.vercel.app
```

Or edit `lib/core/config/app_config.dart` → `cloudApiBase`.

## 5. Test flow

1. Open MindTouch on Android → enable Accessibility
2. Open `https://YOUR-PROJECT.vercel.app/admin` in browser
3. Phone appears under **Connected Phones** within ~5 seconds
4. Click **Scroll Down**, **Tap**, **Type Text** — phone executes actions

## Local dev (optional)

```bash
npm install
npx vercel dev
# Admin: http://localhost:3000/admin
# App: flutter run --dart-define=MINDTOUCH_API=http://10.0.2.2:3000
```

## API routes

| URL | Purpose |
|-----|---------|
| `/admin` | Web dashboard |
| `/api/health` | Health check |
| `/api/auth/register` | Create account + register device |
| `/api/auth/login` | Sign in + register device |
| `/api/auth/me` | Current user (Bearer token) |
| `/api/phone/poll?device_id=` | Phone polls for commands |
| `/api/phone/command` | Admin sends action |
| `/api/phone/direction` | Admin sends AI direction |

## Documentation

| Doc | Link |
|-----|------|
| README | https://github.com/YoussefBaderelden/mindtouch |
| Deploy guide | https://github.com/YoussefBaderelden/mindtouch/blob/main/DEPLOY.md |
| Architecture | https://github.com/YoussefBaderelden/mindtouch/blob/main/docs/ARCHITECTURE.md |

## One-click cloud deploy

- **Vercel:** https://vercel.com/new/clone?repository-url=https://github.com/YoussefBaderelden/mindtouch
- **Render:** https://render.com/deploy?repo=https://github.com/YoussefBaderelden/mindtouch

## Docker backend (optional local)

For full FastAPI + Postgres locally:

```bash
cd infra && docker compose up -d
```

Cloud testing uses **Vercel only** — Docker not required.
