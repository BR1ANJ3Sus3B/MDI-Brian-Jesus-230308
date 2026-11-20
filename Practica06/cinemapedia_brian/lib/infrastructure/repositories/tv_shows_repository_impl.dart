import 'package:cinemapedia/domain/datasources/tv_shows_datasource.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/tv_shows_repository.dart';

class TvShowsRepositoryImpl extends TvShowsRepository {
  TvShowsRepositoryImpl(this._datasource);

  final TvShowsDatasource _datasource;

  @override
  Future<List<TvShow>> getOnTheAir({int page = 1}) =>
      _datasource.getOnTheAir(page: page);

  @override
  Future<List<TvShow>> getPopular({int page = 1}) =>
      _datasource.getPopular(page: page);

  @override
  Future<List<TvShow>> getTopRated({int page = 1}) =>
      _datasource.getTopRated(page: page);
}
