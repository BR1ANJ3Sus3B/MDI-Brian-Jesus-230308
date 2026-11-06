import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/regional_release_info.dart';

abstract class MoviesDatasource {
  Future<List<Movie>> getNowPlaying({int page = 1});

  Future<List<Movie>> getPopular({int page = 1});

  Future<List<Movie>> getUpcoming({int page = 1});

  Future<List<Movie>> getTopRated({int page = 1});

  Future<Movie> getMovieById(String id);

  Future<RegionalReleaseInfo> getRegionalReleaseInfo(
      int movieId, String regionCode);

  Future<List<Movie>> searchMovies(String query);
}
