import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nowPlayingMoviesProvider =
    StateNotifierProvider<MoviesNotifier, MoviesState>((ref) {
      final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

      return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
    });

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesState {
  const MoviesState({
    this.movies = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Movie> movies;
  final bool isLoading;
  final String? errorMessage;

  MoviesState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MoviesState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class MoviesNotifier extends StateNotifier<MoviesState> {
  int currentPage = 0;
  final MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super(const MoviesState());

  Future<void> loadNextPage() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);
    currentPage++;
    try {
      final movies = await fetchMoreMovies(page: currentPage);
      state = state.copyWith(
        movies: [...state.movies, ...movies],
        isLoading: false,
      );
    } catch (_) {
      currentPage--;
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudieron cargar las películas. Verifica THE_MOVIEDB_KEY en .env.',
      );
    }
  }
}
