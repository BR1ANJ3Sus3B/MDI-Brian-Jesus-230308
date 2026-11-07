import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';

import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/domain/entities/regional_release_info.dart';

class MoviedbDatasource extends MoviesDatasource {
  MoviedbDatasource(this.region)
      : dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          queryParameters: {
            'api_key': Environment.theMovieDbKey,
            'language': region.languageCode,
          },
        )),
        releaseDatesDio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          queryParameters: {'api_key': Environment.theMovieDbKey},
        ));

  final CinemaRegion region;
  final Dio dio;
  final Dio releaseDatesDio;
  final Map<int, Future<Map<String, dynamic>>> _englishFallbacks = {};

  Future<Map<String, dynamic>> _withFallback(
      Map<String, dynamic> source) async {
    final data = Map<String, dynamic>.from(source);
    bool missing(String field) => (data[field] as String? ?? '').trim().isEmpty;
    if (region.languageCode != 'en-US' &&
        (missing('title') || missing('overview'))) {
      try {
        final id = data['id'] as int;
        final fallback = await _englishFallbacks.putIfAbsent(id, () async {
          final response = await dio
              .get('/movie/$id', queryParameters: {'language': 'en-US'});
          return Map<String, dynamic>.from(response.data);
        });
        // Only fill missing textual fields for this same movie. Never replace
        // the regional release date, certification, order or membership.
        for (final field in ['title', 'overview']) {
          if (missing(field)) data[field] = fallback[field] ?? '';
        }
      } catch (_) {
        _englishFallbacks.remove(data['id']);
        // Keep the successful regional response if the optional fallback fails.
      }
    }
    if (missing('title')) data['title'] = data['original_title'] ?? '';
    data['overview'] ??= '';
    return data;
  }

  Future<List<Movie>> _jsonToMovies(Map<String, dynamic> json) async {
    final results = await Future.wait((json['results'] as List<dynamic>)
        .map((item) => _withFallback(Map<String, dynamic>.from(item))));
    final movieDBResponse =
        MovieDbResponse.fromJson({...json, 'results': results});

    final List<Movie> movies = movieDBResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map((moviedb) => MovieMapper.movieDBToEntity(moviedb))
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {
      'page': page,
      'region': region.code,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {
      'page': page,
      'region': region.code,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {
      'page': page,
      'region': region.code,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {
      'page': page,
      'region': region.code,
    });

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id not found');
    }

    final movieDetails =
        MovieDetails.fromJson(await _withFallback(response.data));
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDetails);
    return movie;
  }

  @override
  Future<RegionalReleaseInfo> getRegionalReleaseInfo(
      int movieId, String regionCode) async {
    final response = await releaseDatesDio.get('/movie/$movieId/release_dates');
    final countryReleases = (response.data['results'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .where((country) => country['iso_3166_1'] == regionCode)
        .expand((country) => (country['release_dates'] as List<dynamic>? ?? [])
            .whereType<Map<String, dynamic>>())
        .toList();

    String? certification;
    DateTime? releaseDate;
    for (final type in [3, 2, 4, 5, 6, 1]) {
      for (final release in countryReleases) {
        if (release['type'] != type) continue;
        final value = (release['certification'] as String? ?? '').trim();
        certification ??= value.isEmpty ? null : value;
        releaseDate ??=
            DateTime.tryParse(release['release_date']?.toString() ?? '');
        if (certification != null && releaseDate != null) {
          return RegionalReleaseInfo(
            certification: certification,
            releaseDate: releaseDate,
          );
        }
      }
    }
    return RegionalReleaseInfo(
      certification: certification,
      releaseDate: releaseDate,
    );
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final response = await dio.get('/search/movie', queryParameters: {
      'query': query,
      'region': region.code,
    });

    return _jsonToMovies(response.data);
  }
}
