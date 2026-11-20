import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:flutter/material.dart';

class TvShowPosterCard extends StatelessWidget {
  const TvShowPosterCard({super.key, required this.show, this.width = 148});

  final TvShow show;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          color: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(show.posterPath, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const _PosterFallback()),
                Positioned(left: 8, bottom: 8, child: _RatingBadge(show.voteAverage)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(show.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.2)),
                if (show.firstAirDate != null) ...[
                  const SizedBox(height: 5),
                  Text('${show.firstAirDate!.year}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.secondaryText)),
                ],
              ]),
            ),
          ]),
        ),
      );
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge(this.rating);
  final double rating;
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: .72), borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star_rounded, size: 15, color: AppColors.amber),
            const SizedBox(width: 3),
            Text(rating <= 0 ? '—' : '${HumanFormats.rating(rating, Localizations.localeOf(context).toString())} / 10', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback();
  @override
  Widget build(BuildContext context) => const ColoredBox(
        color: AppColors.surface,
        child: Center(child: Icon(Icons.tv_outlined, size: 38, color: AppColors.secondaryText)),
      );
}
