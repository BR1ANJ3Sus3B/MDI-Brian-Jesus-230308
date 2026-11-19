import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/domain/datasources/tv_shows_datasource.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:dio/dio.dart';

class MoviedbTvDatasource extends TvShowsDatasource {
  MoviedbTvDatasource(this.region)
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.themoviedb.org/3',
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          queryParameters: {
            'api_key': Environment.theMovieDbKey,
            'language': region.languageCode,
          },
        ));

  final CinemaRegion region;
  final Dio _dio;

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) =>
      _getShows('/tv/on_the_air', page);

  @override
  Future<List<TvShow>> getPopular({int page = 1}) =>
      _getShows('/tv/popular', page);

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) =>
      _getShows('/tv/top_rated', page);

  Future<List<TvShow>> _getShows(String path, int page) async {
    final response = await _dio.get(path, queryParameters: {
      'page': page,
      'region': region.code,
    });
    final results = response.data['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(_toEntity)
        .where((show) => show.posterPath.isNotEmpty)
        .toList();
  }

  TvShow _toEntity(Map<String, dynamic> json) {
    final poster = json['poster_path'] as String? ?? '';
    return TvShow(
      id: json['id'] as int,
      name: (json['name'] as String? ?? '').trim().isEmpty
          ? 'Sin título'
          : json['name'] as String,
      originalName: json['original_name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: poster.isEmpty ? '' : 'https://image.tmdb.org/t/p/w500$poster',
      firstAirDate: DateTime.tryParse(json['first_air_date'] as String? ?? ''),
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
    );
  }
}
