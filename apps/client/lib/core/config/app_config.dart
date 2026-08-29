/// Central performance & stability tuning — single source of truth.
abstract final class AppConfig {
  /// Minimum gap between phone OS actions (prevents gesture pile-up / ANR).
  static const actionMinIntervalMs = 180;

  /// Max queued actions before dropping oldest (memory + flood protection).
  static const maxActionQueueSize = 8;

  /// Ignore duplicate directions within this window.
  static const directionDebounceMs = 140;

  /// WebSocket reconnect backoff (local Docker backend only).
  static const wsReconnectBaseMs = 2000;
  static const wsReconnectMaxMs = 30000;

  /// Cloud API base URL — set via: flutter run --dart-define=MINDTOUCH_API=https://xxx.vercel.app
  /// When empty, the app uses the local Node API at 10.0.2.2:3000 (started by scripts/run-app.ps1).
  static const cloudApiBase = String.fromEnvironment(
    'MINDTOUCH_API',
    defaultValue: '',
  );

  /// Default local API (npm start) — Android emulator loopback.
  static const localApiBase = 'http://10.0.2.2:3000';

  /// Use cloud polling when MINDTOUCH_API is set, else local npm server.
  static String get apiBase {
    if (cloudApiBase.isNotEmpty) return cloudApiBase.replaceAll(RegExp(r'/$'), '');
    return localApiBase;
  }

  static String get phoneApiPrefix => '/api/phone';

  static bool get useCloudApi => cloudApiBase.isNotEmpty;

  /// Phone poll interval for Vercel cloud (serverless-safe).
  static const phonePollIntervalMs = 400;

  /// Local WebSocket (Docker backend only).
  static const defaultBackendWs = 'ws://10.0.2.2:8080/v1/phone/control';

  /// Accessibility poll interval when returning from settings.
  static const accessibilityPollMs = 1500;

  /// Max execution log entries kept in memory.
  static const maxExecutionLogs = 40;

  /// Overlay auto-dismiss to avoid blocking subsequent actions.
  static const feedbackAutoDismissMs = 900;
}
