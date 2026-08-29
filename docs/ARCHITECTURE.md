# MindTouch Architecture

Production-oriented structure for stability, performance, and testability.

## Client layers

```
lib/
├── core/
│   ├── config/          AppConfig — all timing & limits in one place
│   └── stability/         Crash guards, bootstrap
├── domain/
│   ├── models/            Pure data (Direction, PhoneAction, …)
│   ├── navigation/        Matrix layouts + action registry
│   └── services/          ActionPipeline — serialized OS command queue
├── data/
│   ├── database/          Drift SQLite (offline-first)
│   └── services/          RemoteControlService (WebSocket + backoff)
├── platform/              MethodChannel bridge (Android Accessibility)
└── presentation/
    ├── providers/         Riverpod state
    ├── screens/           UI screens
    └── widgets/           Reusable UI (RepaintBoundary on hot paths)
```

## Action flow (no crashes, no pile-up)

```
Input (AI / matrix / admin WS)
        ↓
ActionPipeline (Dart) — debounce + queue + 180ms min gap
        ↓
MethodChannel
        ↓
MindTouchAccessibilityService (Kotlin) — main-thread queue + 160ms gap
        ↓
Android OS (tap / scroll / back / type)
```

## Stability rules

| Rule | Why |
|------|-----|
| One action at a time | Prevents gesture conflicts & ANR |
| Debounce duplicate directions | Stops AI noise from flooding OS |
| Max queue size 8 | Memory bound under spam |
| Recycle AccessibilityNodeInfo | Prevents native memory leaks |
| try/catch on all platform calls | Never crash on failed gesture |
| Exponential WS reconnect | Survives network blips |
| Auto-dismiss feedback overlay | UI never blocks next action |

## Performance targets

- Action dispatch: **< 50ms** software overhead (excl. OS gesture)
- Min gap between gestures: **160–180ms** (tunable in AppConfig)
- Matrix cells: **RepaintBoundary** isolated repaints
- Neural background: lightweight 12-node mesh

## Android requirements

1. Enable **MindTouch Control** in Accessibility settings
2. Disable battery optimization (Setup wizard)
3. For physical device: set PC IP in `AppConfig.defaultBackendWs`
