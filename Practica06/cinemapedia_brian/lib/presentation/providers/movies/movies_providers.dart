import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  return MoviesNotifier(
      fetchMoreMovies: fetchMoreMovies, errorKey: 'nowPlaying', ref: ref);
});

final popularMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  return MoviesNotifier(
      fetchMoreMovies: fetchMoreMovies, errorKey: 'popular', ref: ref);
});

final upcomingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;
  return MoviesNotifier(
      fetchMoreMovies: fetchMoreMovies, errorKey: 'upcoming', ref: ref);
});

final topRatedMoviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  return MoviesNotifier(
      fetchMoreMovies: fetchMoreMovies, errorKey: 'topRated', ref: ref);
});

final movieSectionErrorsProvider =
    StateProvider<Map<String, String>>((ref) => const {});

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends StateNotifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;
  final String errorKey;
  final Ref ref;
  bool _disposed = false;

  MoviesNotifier({
    required this.fetchMoreMovies,
    required this.errorKey,
    required this.ref,
  }) : super([]);

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;
    final requestedPage = currentPage + 1;
    try {
      final movies = await fetchMoreMovies(page: requestedPage);
      if (_disposed) return;
      final knownIds = state.map((movie) => movie.id).toSet();
      state = [
        ...state,
        ...movies.where((movie) => knownIds.add(movie.id)),
      ];
      currentPage = requestedPage;
      _updateError(null);
    } catch (_) {
      if (_disposed) return;
      _updateError('No se pudo cargar esta colección. Comprueba tu conexión.');
    } finally {
      if (!_disposed) isLoading = false;
    }
  }

  void _updateError(String? message) {
    final errors = {...ref.read(movieSectionErrorsProvider)};
    if (message == null) {
      errors.remove(errorKey);
    } else {
      errors[errorKey] = message;
    }
    ref.read(movieSectionErrorsProvider.notifier).state = errors;
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
