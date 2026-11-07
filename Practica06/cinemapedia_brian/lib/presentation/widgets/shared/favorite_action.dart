import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> toggleFavorite(
    BuildContext context, WidgetRef ref, Movie movie) async {
  try {
    await ref.read(favoriteMoviesProvider.notifier).toggle(movie);
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.favoriteError)),
    );
  }
}
