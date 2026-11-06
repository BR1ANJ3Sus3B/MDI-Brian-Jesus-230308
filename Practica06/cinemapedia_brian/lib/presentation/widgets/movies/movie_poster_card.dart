import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoviePosterCard extends StatelessWidget {
  const MoviePosterCard({super.key, required this.movie, this.width = 148});

  final Movie movie;
  final double width;

  @override
  Widget build(BuildContext context) {
    final releaseYear = movie.releaseDate.year > 1900
        ? movie.releaseDate.year.toString()
        : null;

    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        color: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: InkWell(
          onTap: () => context.push('/movie/${movie.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2 / 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.posterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const _PosterFallback(),
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                              ? child
                              : const _PosterFallback(isLoading: true),
                    ),
                    Positioned(
                        top: 7, right: 7, child: _FavoriteToggle(movie: movie)),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: _RatingBadge(rating: movie.voteAverage),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                    ),
                    if (releaseYear != null) ...[
                      const SizedBox(height: 5),
                      Text(
                        releaseYear,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteToggle extends ConsumerWidget {
  const _FavoriteToggle({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite =
        ref.watch(favoriteMoviesProvider).any((item) => item.id == movie.id);
    return Material(
      color: Colors.black.withValues(alpha: 0.56),
      shape: const CircleBorder(),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
        onPressed: () =>
            ref.read(favoriteMoviesProvider.notifier).toggle(movie),
        icon: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorite ? AppColors.cyan : Colors.white,
          size: 19,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final label = rating <= 0 ? '—' : HumanFormats.rating(rating);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 15, color: AppColors.amber),
            const SizedBox(width: 3),
            Text(rating <= 0 ? label : '$label / 10',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(strokeWidth: 2)
              : const Icon(Icons.movie_outlined,
                  size: 38, color: AppColors.secondaryText),
        ),
      );
}
