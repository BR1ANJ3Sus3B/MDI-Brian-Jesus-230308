import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// A regional view of saved IDs; never overwrites or removes persisted favorites.
final localizedFavoritesProvider = FutureProvider<List<Movie>>((ref) async {
  final favorites = ref.watch(favoriteMoviesProvider);
  if (favorites.isEmpty) return const [];
  final repository = ref.watch(movieRepositoryProvider);
  return Future.wait(favorites.map((saved) async {
    try {
      return await repository.getMovieById(saved.id.toString());
    } catch (_) {
      return saved; // Keep the offline copy if TMDB is unavailable.
    }
  }));
});
