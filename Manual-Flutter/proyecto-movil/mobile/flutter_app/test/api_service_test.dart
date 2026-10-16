import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:app_mobile/services/api_service.dart';

void main() {
  test('POST sends JSON and Bearer token', () async {
    final api = ApiService.withToken((_) async => 'test-token', client: MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.headers['Authorization'], 'Bearer test-token');
      expect(jsonDecode(request.body)['title'], 'Study');
      return http.Response('{"id":1}', 201);
    }));
    addTearDown(api.close);
    expect((await api.request('POST', '/tasks', body: {'title': 'Study'}))['id'], 1);
  });

  test('401 refreshes once and then stops', () async {
    var requests = 0;
    final refreshes = <bool>[];
    final api = ApiService.withToken((refresh) async {
      refreshes.add(refresh); return 'test-token';
    }, client: MockClient((_) async { requests++; return http.Response('{"detail":"Expired"}', 401); }));
    addTearDown(api.close);
    await expectLater(api.request('GET', '/tasks'), throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)));
    expect(requests, 2);
    expect(refreshes, [false, true]);
  });

  test('403 is not retried', () async {
    var requests = 0;
    final api = ApiService.withToken((_) async => 'token', client: MockClient((_) async {
      requests++; return http.Response('{"detail":"Forbidden"}', 403);
    }));
    addTearDown(api.close);
    await expectLater(api.request('GET', '/tasks'), throwsA(isA<ApiException>().having((e) => e.status, 'status', 403)));
    expect(requests, 1);
  });

  test('invalid JSON and network errors become readable failures', () async {
    for (final failNetwork in [false, true]) {
      final api = ApiService.withToken((_) async => 'token', client: MockClient((_) async {
        if (failNetwork) throw http.ClientException('offline');
        return http.Response('<html>failure</html>', 200);
      }));
      await expectLater(api.request('GET', '/tasks'), throwsA(isA<ApiException>().having((e) => e.status, 'status', 0)));
      api.close();
    }
  });
}
