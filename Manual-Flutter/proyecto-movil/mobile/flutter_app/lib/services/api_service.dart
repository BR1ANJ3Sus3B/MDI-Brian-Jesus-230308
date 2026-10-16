import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'auth_service.dart';

class ApiException implements Exception {
  final int status;
  final String message;
  const ApiException(this.status, this.message);
  @override
  String toString() => message;
}

class ApiService {
  final Future<String> Function(bool forceRefresh) token;
  final http.Client client;
  ApiService(AuthService auth, {http.Client? client})
      : token = ((forceRefresh) => auth.accessToken(forceRefresh: forceRefresh)),
        client = client ?? http.Client();
  ApiService.withToken(this.token, {required this.client});

  Future<dynamic> request(String method, String path, {Map<String, dynamic>? body}) async {
    try {
      for (var attempt = 0; attempt < 2; attempt++) {
        final accessToken = await token(attempt == 1);
        final request = http.Request(method, Uri.parse('${Config.apiUrl}$path'));
        request.headers.addAll({'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'});
        if (body != null) request.body = jsonEncode(body);
        final response = await _send(request).timeout(const Duration(seconds: 15));
        if (response.statusCode == 401 && attempt == 0) continue;
        final data = response.body.isEmpty ? null : jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode < 200 || response.statusCode >= 300) {
          final message = data is Map ? data['detail']?.toString() : null;
          throw ApiException(response.statusCode, message ?? 'Error HTTP ${response.statusCode}');
        }
        return data;
      }
      throw const ApiException(401, 'La sesión no es válida.');
    } on TimeoutException {
      throw const ApiException(0, 'La API tardó demasiado. Comprueba la conexión.');
    } on http.ClientException {
      throw const ApiException(0, 'No se pudo conectar con la API. Revisa los puertos y la red.');
    } on FormatException {
      throw const ApiException(0, 'La API devolvió una respuesta que no es JSON válido.');
    }
  }

  Future<http.Response> _send(http.Request request) async => http.Response.fromStream(await client.send(request));
  void close() => client.close();
}
