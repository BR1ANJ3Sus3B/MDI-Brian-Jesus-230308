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

  test(
      'fallback fills only missing text for the same ID and keeps regional dates',
      () async {
    final adapter = _RecordingAdapter(respond: (request) {
      if (request.path == '/movie/10') {
        expect(request.queryParameters['language'], 'en-US');
        expect(request.queryParameters.containsKey('region'), isFalse);
        return {
          'id': 10,
          'title': 'English title',
          'overview': 'English synopsis',
          'release_date': '2020-01-01'
        };
      }
      return {
        'page': 1,
        'total_pages': 1,
        'total_results': 1,
        'results': [
          {
            'id': 10,
            'title': '日本語の題名',
            'overview': '',
            'original_title': 'Original',
            'genre_ids': [],
            'poster_path': '/poster.jpg',
            'release_date': '2026-11-06'
          },
        ]
      };
    });
    final datasource = MoviedbDatasource(CinemaRegion.fromCode('JP'))
      ..dio.httpClientAdapter = adapter;
    final movies = await datasource.getNowPlaying();
    expect(movies.single.title, '日本語の題名');
    expect(movies.single.overview, 'English synopsis');
    expect(movies.single.releaseDate, DateTime(2026, 11, 6));
    await datasource.getNowPlaying();
    expect(adapter.requests.where((request) => request.path == '/movie/10'),
        hasLength(1));
  });

  test('optional fallback failure preserves movie and its original title',
      () async {
    final adapter = _RecordingAdapter(respond: (request) {
      if (request.path == '/movie/10') throw StateError('offline');
      return {
        'page': 1,
        'total_pages': 1,
        'total_results': 1,
        'results': [
          {
            'id': 10,
            'title': '',
            'overview': '',
            'original_title': 'Original',
            'genre_ids': []
          },
        ]
      };
    });
    final datasource = MoviedbDatasource(CinemaRegion.mexico)
      ..dio.httpClientAdapter = adapter;
    final movies = await datasource.getNowPlaying();
    expect(movies.single.title, 'Original');
    expect(movies.single.overview, isEmpty);
    expect(movies.single.releaseDate.year, 1900);
  });

  test('all seven countries retain only their official certification',
      () async {
    const certificates = {
      'US': 'PG-13',
      'MX': 'B15',
      'DE': '16',
      'JP': 'R15+',
      'CN': '',
      'RU': '16+',
      'BR': '14'
    };
    final adapter = _RecordingAdapter(releaseDates: {
      'results': [
        for (final entry in certificates.entries)
          {
            'iso_3166_1': entry.key,
            'release_dates': [
              {
                'type': 3,
                'certification': entry.value,
                'release_date': '2026-11-06T00:00:00Z'
              },
            ]
          },
      ]
    });
    final datasource = MoviedbDatasource(CinemaRegion.mexico)
      ..releaseDatesDio.httpClientAdapter = adapter;
    for (final entry in certificates.entries) {
      final result = await datasource.getRegionalReleaseInfo(10, entry.key);
      expect(result.certification, entry.value.isEmpty ? null : entry.value);
    }
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter({this.releaseDates, this.respond});
  final Map<String, Object?> Function(RequestOptions)? respond;

  final Map<String, Object?>? releaseDates;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final response = respond != null
        ? respond!(options)
        : options.path.contains('/release_dates')
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
