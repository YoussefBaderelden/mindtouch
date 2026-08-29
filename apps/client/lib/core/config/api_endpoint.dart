import 'package:http/http.dart' as http;

import 'app_config.dart';
import 'cloud_urls.dart';

/// Resolves the API base URL at startup — Vercel cloud first, local fallback.
abstract final class ApiEndpoint {
  static String _base = CloudUrls.apiBase;
  static bool _initialized = false;

  static String get base => _base;
  static bool get isCloud => !_base.contains('10.0.2.2') && !_base.contains('localhost');

  static Future<void> initialize() async {
    if (_initialized) return;

    if (AppConfig.useLocalApi) {
      _base = AppConfig.localApiBase;
      _initialized = true;
      return;
    }

    if (CloudUrls.fromEnvironment.isNotEmpty) {
      _base = CloudUrls.apiBase;
      _initialized = true;
      return;
    }

    try {
      final health = Uri.parse('${CloudUrls.production}/api/health');
      final res = await http.get(health).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        _base = CloudUrls.production;
        _initialized = true;
        return;
      }
    } catch (_) {}

    _base = AppConfig.localApiBase;
    _initialized = true;
  }
}
