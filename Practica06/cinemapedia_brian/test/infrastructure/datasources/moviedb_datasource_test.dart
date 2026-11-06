import 'dart:convert';
import 'dart:typed_data';

import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() => dotenv.testLoad(fileInput: 'THE_MOVIEDB_KEY=test-key'));

  test('sends each selected language and region to regional list endpoints',
      () async {
    for (final region in CinemaRegion.all) {
      final adapter = _RecordingAdapter();
      final datasource = MoviedbDatasource(region)
        ..dio.httpClientAdapter = adapter
        ..releaseDatesDio.httpClientAdapter = adapter;

      await datasource.getNowPlaying();
      await datasource.getUpcoming();
      await datasource.getPopular();
      await datasource.getTopRated();
      await datasource.searchMovies('cinema');

      expect(adapter.requests, hasLength(5));
      for (final request in adapter.requests) {
        expect(request.queryParameters['language'], region.languageCode);
        expect(request.queryParameters['region'], region.code);
      }
    }
  });

  test('returns only the certification from the requested country unchanged',
      () async {
    final adapter = _RecordingAdapter(releaseDates: {
      'id': 10,
      'results': [
        {
          'iso_3166_1': 'MX',
          'release_dates': [
            {
              'certification': 'B15',
              'release_date': '2026-04-12T00:00:00.000Z',
              'type': 3,
            },
          ],
        },
        {
          'iso_3166_1': 'DE',
          'release_dates': [
            {
              'certification': '16',
              'release_date': '2026-04-12T00:00:00.000Z',
              'type': 3,
            },
          ],
        },
      ],
    });
    final datasource = MoviedbDatasource(CinemaRegion.mexico)
      ..dio.httpClientAdapter = adapter
      ..releaseDatesDio.httpClientAdapter = adapter;

    final mexico = await datasource.getRegionalReleaseInfo(10, 'MX');
    final germany = await datasource.getRegionalReleaseInfo(10, 'DE');
    final china = await datasource.getRegionalReleaseInfo(10, 'CN');
    expect(mexico.certification, 'B15');
    expect(mexico.releaseDate, DateTime.utc(2026, 4, 12));
    expect(germany.certification, '16');
    expect(china.certification, isNull);
    expect(china.releaseDate, isNull);
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({this.releaseDates});

  final Map<String, Object?>? releaseDates;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = options.path.contains('/release_dates')
        ? releaseDates ?? {'id': 10, 'results': []}
        : {
            'page': 1,
            'results': [],
            'total_pages': 1,
            'total_results': 0,
          };
    return ResponseBody.fromString(
      jsonEncode(response),
      200,
      headers: const {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
