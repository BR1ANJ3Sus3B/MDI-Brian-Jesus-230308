import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class SessionException implements Exception {
  final String message;
  const SessionException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Map<String, dynamic>? _session;
  Future<String>? _refreshing;
  bool get hasSession => _session != null;

  Future<void> restore() async {
    final raw = await _storage.read(key: 'session');
    if (raw == null) return;
    try {
      _session = jsonDecode(raw) as Map<String, dynamic>;
      await accessToken();
    } catch (_) { await clear(); }
  }

  Future<void> login() async {
    final result = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
      Config.clientId, Config.redirectUri, issuer: Config.issuer,
      scopes: ['openid', 'profile', 'email'], allowInsecureConnections: Config.allowHttp,
    ));
    await _save(result);
  }

  Future<void> _save(TokenResponse result) async {
    if (result.accessToken == null) throw const SessionException('No se recibió un access token.');
    _session = {
      'access_token': result.accessToken,
      'refresh_token': result.refreshToken ?? _session?['refresh_token'],
      'id_token': result.idToken ?? _session?['id_token'],
      'expires_at': (result.accessTokenExpirationDateTime ?? DateTime.now()).toUtc().toIso8601String(),
    };
    await _storage.write(key: 'session', value: jsonEncode(_session));
  }

  Future<String> accessToken({bool forceRefresh = false}) async {
    if (_session == null) throw const SessionException('Inicia sesión.');
    final expiry = DateTime.parse(_session!['expires_at'] as String);
    if (!forceRefresh && expiry.isAfter(DateTime.now().add(const Duration(seconds: 30)))) {
      return _session!['access_token'] as String;
    }
    // Las solicitudes simultáneas comparten una sola renovación.
    final pending = _refreshing;
    if (pending != null) return pending;
    final future = _refresh();
    _refreshing = future;
    try { return await future; } finally { _refreshing = null; }
  }

  Future<String> _refresh() async {
    final refreshToken = _session?['refresh_token'] as String?;
    if (refreshToken == null) {
      await clear();
      throw const SessionException('La sesión venció. Inicia sesión de nuevo.');
    }
    try {
      final result = await _appAuth.token(TokenRequest(
        Config.clientId, Config.redirectUri, issuer: Config.issuer,
        refreshToken: refreshToken, scopes: ['openid', 'profile', 'email'],
        allowInsecureConnections: Config.allowHttp,
      ));
      await _save(result);
      return _session!['access_token'] as String;
    } catch (_) {
      await clear();
      throw const SessionException('No se pudo renovar la sesión. Inicia sesión nuevamente.');
    }
  }

  Future<void> clear() async {
    _session = null;
    await _storage.delete(key: 'session');
  }

  Future<void> logout() async {
    final idToken = _session?['id_token'] as String?;
    await clear();
    if (idToken != null) {
      await _appAuth.endSession(EndSessionRequest(
        issuer: Config.issuer, idTokenHint: idToken,
        postLogoutRedirectUrl: Config.logoutUri, allowInsecureConnections: Config.allowHttp,
      ));
    }
  }
}
