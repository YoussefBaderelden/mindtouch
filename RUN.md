# MindTouch — Run the app (cloud Vercel by default)

The mobile app connects to **Vercel** automatically. No local server needed.

## Run the app

```powershell
cd "e:\flutter in AS\mindtouch\apps\client"
flutter run -d emulator-5554
```

## Deploy backend to Vercel (one-time)

See **[VERCEL.md](VERCEL.md)** — login once, run `.\scripts\deploy-vercel.ps1`.

## Local dev (optional)

```powershell
# Terminal 1
cd "e:\flutter in AS\mindtouch"
npm start

# Terminal 2
cd apps/client
flutter run --dart-define=MINDTOUCH_LOCAL=true
```

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
