import 'dart:developer' as developer;

import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/domain/repositories/tv_shows_repository.dart';
import 'package:cinemapedia/infrastructure/datasources/moviedb_tv_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/tv_shows_repository_impl.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tvShowsRepositoryProvider = Provider<TvShowsRepository>((ref) {
  return TvShowsRepositoryImpl(
      MoviedbTvDatasource(ref.watch(selectedRegionProvider)));
});

final onTheAirTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>(
        (ref) => TvShowsNotifier(
              fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getOnTheAir,
            ));

final popularTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>(
        (ref) => TvShowsNotifier(
              fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getPopular,
            ));

final topRatedTvShowsProvider =
    StateNotifierProvider<TvShowsNotifier, List<TvShow>>(
        (ref) => TvShowsNotifier(
              fetchMoreShows: ref.watch(tvShowsRepositoryProvider).getTopRated,
            ));

typedef TvShowsCallback = Future<List<TvShow>> Function({int page});

class TvShowsNotifier extends StateNotifier<List<TvShow>> {
  TvShowsNotifier({required this.fetchMoreShows}) : super(const []);

  final TvShowsCallback fetchMoreShows;
  int _page = 0;
  bool _loading = false;

  Future<void> loadNextPage() async {
    if (_loading) return;
    _loading = true;
    try {
      final shows = await fetchMoreShows(page: _page + 1);
      final ids = state.map((show) => show.id).toSet();
      state = [...state, ...shows.where((show) => ids.add(show.id))];
      _page++;
    } catch (exception, stackTrace) {
      developer.log(
        'Unable to load TV shows',
        name: 'cinemapedia.tv',
        error: exception,
        stackTrace: stackTrace,
      );
    } finally {
      _loading = false;
    }
  }
}
