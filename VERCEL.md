# Deploy MindTouch to Vercel (one-time setup)

## Step 1 — Login (once, in browser)

```powershell
cd "e:\flutter in AS\mindtouch"
npx vercel login
```

Choose **Continue with GitHub** (same account as your repo).

## Step 2 — Deploy

```powershell
.\scripts\deploy-vercel.ps1
```

This deploys admin + API + auth to Vercel and updates the mobile app URL automatically.

## Step 3 — Add Redis (required for auth + phone commands)

1. Open your project on [vercel.com/dashboard](https://vercel.com/dashboard)
2. **Storage** → **Create Database** → **Upstash Redis** → Connect
3. **Redeploy** the project

## One-click (alternative)

https://vercel.com/new/clone?repository-url=https://github.com/YoussefBaderelden/mindtouch

Then add Upstash Redis and copy your URL into `apps/client/lib/core/config/cloud_urls.dart`.

## Your URLs after deploy

| Service | URL |
|---------|-----|
| Admin | `https://YOUR-PROJECT.vercel.app/admin` |
| API | `https://YOUR-PROJECT.vercel.app/api/health` |
| Auth | `https://YOUR-PROJECT.vercel.app/api/auth/register` |

## Run mobile app (uses Vercel by default)

```powershell
cd apps/client
flutter run -d emulator-5554
```

Local API only if needed:

```powershell
flutter run --dart-define=MINDTOUCH_LOCAL=true
```
