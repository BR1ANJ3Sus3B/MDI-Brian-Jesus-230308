import 'package:flutter/foundation.dart';

class Config {
  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000');
  static const issuer = String.fromEnvironment('ISSUER', defaultValue: 'http://localhost:8080/realms/app-mobile');
  static const clientId = 'flutter-mobile';
  static const redirectUri = 'com.example.appmobile:/oauthredirect';
  static const logoutUri = 'com.example.appmobile:/logout';
  static const allowHttp = kDebugMode;
}
