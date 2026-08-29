import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../platform/platform_service.dart';

class AuthUser {
  const AuthUser({
    required this.email,
    required this.accessToken,
    this.displayName,
    this.userId,
  });

  final String email;
  final String accessToken;
  final String? displayName;
  final String? userId;
}

class AuthService {
  AuthService(this._platform);

  final PlatformService _platform;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'mt_access_token';
  static const _emailKey = 'mt_email';
  static const _nameKey = 'mt_display_name';

  String get _base => AppConfig.apiBase;

  Future<AuthUser?> getStoredUser() async {
    final token = await _storage.read(key: _tokenKey);
    final email = await _storage.read(key: _emailKey);
    if (token == null || email == null) return null;
    return AuthUser(
      email: email,
      accessToken: token,
      displayName: await _storage.read(key: _nameKey),
    );
  }

  Future<AuthUser> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final device = await _platform.getDeviceProfile();
    final res = await http.post(
      Uri.parse('$_base/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'display_name': displayName,
        'device': device.toJson(),
      }),
    );
    if (res.statusCode >= 400) {
      throw Exception(_parseError(res.body, res.statusCode));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return _persistUser(email, data, displayName);
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final device = await _platform.getDeviceProfile();
    final res = await http.post(
      Uri.parse('$_base/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'device': device.toJson(),
      }),
    );
    if (res.statusCode >= 400) {
      throw Exception(_parseError(res.body, res.statusCode));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return _persistUser(email, data, null);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  Future<AuthUser> _persistUser(
    String email,
    Map<String, dynamic> data,
    String? displayName,
  ) async {
    final token = data['access_token'] as String;
    final name = displayName ?? email.split('@').first;
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _nameKey, value: name);
    return AuthUser(
      email: email,
      accessToken: token,
      displayName: name,
      userId: data['user_id'] as String?,
    );
  }

  String _parseError(String body, int statusCode) {
    try {
      final data = jsonDecode(body) as Map<String, dynamic>;
      return data['error'] as String? ??
          data['detail'] as String? ??
          'Authentication failed ($statusCode)';
    } catch (_) {
      if (body.contains('Not found') || statusCode == 404) {
        return 'API server outdated — restart npm start on your PC';
      }
      return 'Authentication failed ($statusCode)';
    }
  }
}
