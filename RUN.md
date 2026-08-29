# MindTouch — Run the app (one command)

Everything is configured. You only need to run the script below.

## Quick start (recommended)

```powershell
cd "e:\flutter in AS\mindtouch"
.\scripts\run-app.ps1
```

This will:
1. Start the API server on port **3000** (if not already running)
2. Launch the Flutter app on your Android emulator or device
3. Connect the app to `http://10.0.2.2:3000` automatically

## Manual (if you prefer)

**Terminal 1 — API:**
```powershell
cd "e:\flutter in AS\mindtouch"
npm start
```

**Terminal 2 — App:**
```powershell
cd "e:\flutter in AS\mindtouch\apps\client"
flutter run -d emulator-5554
```

No `--dart-define` needed — the app defaults to the local API.

## Cloud (production)

Deploy once, then run with your URL:

```powershell
flutter run --dart-define=MINDTOUCH_API=https://YOUR-PROJECT.vercel.app
```

Deploy links:
- [Vercel one-click](https://vercel.com/new/clone?repository-url=https://github.com/YoussefBaderelden/mindtouch)
- [Render one-click](https://render.com/deploy?repo=https://github.com/YoussefBaderelden/mindtouch)

## After the app opens

1. **Create account** or **Sign in**
2. Grant all **4 permissions** (Accessibility, bubble, battery, background)
3. Enable **MindTouch Control** in Android Accessibility settings
4. Complete **onboarding** → use **Control** tab
5. Open admin dashboard: http://localhost:3000/admin

## Docs

| Doc | Link |
|-----|------|
| README | https://github.com/YoussefBaderelden/mindtouch |
| Deploy | https://github.com/YoussefBaderelden/mindtouch/blob/main/DEPLOY.md |
| Architecture | https://github.com/YoussefBaderelden/mindtouch/blob/main/docs/ARCHITECTURE.md |
