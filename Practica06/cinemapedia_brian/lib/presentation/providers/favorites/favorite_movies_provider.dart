import 'dart:convert';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoriteMoviesProvider =
    StateNotifierProvider<FavoriteMoviesNotifier, List<Movie>>((ref) {
  return FavoriteMoviesNotifier();
});

class FavoriteMoviesNotifier extends StateNotifier<List<Movie>> {
  static const _storageKey = 'cinemapedia.favoriteMovies.v1';

  late final Future<void> _loaded;

  FavoriteMoviesNotifier() : super(const []) {
    _loaded = _load();
  }

  Future<void> _load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final storedMovies = preferences.getStringList(_storageKey) ?? const [];
      state = storedMovies
          .map((value) => Movie.fromJson(jsonDecode(value)))
          .toList(growable: false);
    } catch (_) {
      state = const [];
    }
  }

  Future<void> toggle(Movie movie) async {
    await _loaded;
    final movies = [...state];
    final existingIndex = movies.indexWhere((item) => item.id == movie.id);
    if (existingIndex >= 0) {
      movies.removeAt(existingIndex);
    } else {
      movies.insert(0, movie);
    }
    state = List.unmodifiable(movies);

    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setStringList(
      _storageKey,
      state.map((item) => jsonEncode(item.toJson())).toList(),
    );
    if (!saved) throw StateError('favorites persistence failed');
  }

  bool contains(int movieId) => state.any((movie) => movie.id == movieId);
}
