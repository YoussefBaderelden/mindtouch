/// Hosted MindTouch API on Vercel.
/// Run `scripts/deploy-vercel.ps1` after login — it updates this URL automatically.
abstract final class CloudUrls {
  /// Set by deploy script. Default matches Vercel project name "mindtouch".
  static const production = 'https://mindtouch.vercel.app';

  /// Override: flutter run --dart-define=MINDTOUCH_API=https://your-url.vercel.app
  static const fromEnvironment = String.fromEnvironment('MINDTOUCH_API', defaultValue: '');

  static String get apiBase {
    if (fromEnvironment.isNotEmpty) {
      return fromEnvironment.replaceAll(RegExp(r'/$'), '');
    }
    return production;
  }
}
