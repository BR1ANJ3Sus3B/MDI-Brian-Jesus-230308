import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/widgets/shared/favorite_action.dart';
import 'package:intl/intl.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_by_movie_provider.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_regional_release_provider.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  const MovieScreen({super.key, required this.movieId});

  final String movieId;

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  String? _loadError;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadMovie);
  }

  Future<void> _loadMovie() async {
    final requestGeneration = ++_loadGeneration;
    try {
      await Future.wait([
        ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId),
        ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId),
      ]);
    } catch (_) {
      if (mounted && requestGeneration == _loadGeneration) {
        setState(() => _loadError = 'movie');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedRegionProvider, (previous, next) {
      if (previous != null && previous.code != next.code) {
        setState(() => _loadError = null);
        _loadMovie();
      }
    });
    final movie = ref.watch(movieInfoProvider)[widget.movieId];
    if (movie == null) {
      return Scaffold(
        drawer: const CinemapediaDrawer(),
        appBar: AppBar(leading: const BackButton()),
        body: Center(
          child: _loadError == null
              ? const CircularProgressIndicator(color: AppColors.cyan)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 40, color: AppColors.secondaryText),
                    const SizedBox(height: 12),
                    Text(context.l10n.movieError),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() => _loadError = null);
                        _loadMovie();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(context.l10n.retry),
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      drawer: const CinemapediaDrawer(),
      body: LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth >= 850;
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: wide ? 470 : 380,
              pinned: true,
              leading: IconButton.filledTonal(
                tooltip: context.l10n.back,
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black45,
                  foregroundColor: Colors.white,
                ),
              ),
              actions: [
                _FavoriteButton(movie: movie),
                Builder(
                  builder: (scaffoldContext) => IconButton(
                    tooltip: context.l10n.openMenu,
                    onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.backdropPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(color: AppColors.surface),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black45,
                            Colors.transparent,
                            AppColors.background
                          ],
                          stops: [0, 0.36, 1],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [AppColors.background, Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        wide ? 36 : 22, 8, wide ? 36 : 22, 48),
                    child: _MovieDetails(movie: movie, wide: wide),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _MovieDetails extends ConsumerWidget {
  const _MovieDetails({required this.movie, required this.wide});

  final Movie movie;
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final actors = ref.watch(actorsByMovieProvider)[movie.id.toString()] ?? [];
    final regionalRelease = ref.watch(movieRegionalReleaseProvider(movie.id));
    final region = ref.watch(selectedRegionProvider);
    final year = movie.releaseDate.year > 1900
        ? movie.releaseDate.year.toString()
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
          Text(movie.tagline!,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.cyan,
                fontStyle: FontStyle.italic,
              )),
          const SizedBox(height: 8),
        ],
        Text(movie.title,
            style: textTheme.displaySmall?.copyWith(
              fontSize: wide ? 46 : 34,
              fontWeight: FontWeight.w900,
              height: 1.08,
            )),
        if (movie.originalTitle != movie.title &&
            movie.originalTitle.trim().isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(movie.originalTitle,
              style: textTheme.bodyLarge
                  ?.copyWith(color: AppColors.secondaryText)),
        ],
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (regionalRelease.asData?.value.releaseDate != null)
              _InfoChip(
                icon: Icons.calendar_month,
                label:
                    DateFormat.yMMMd(Localizations.localeOf(context).toString())
                        .format(regionalRelease.asData!.value.releaseDate!),
              )
            else if (year != null)
              _InfoChip(icon: Icons.calendar_month, label: year),
            if (movie.runtimeMinutes != null)
              _InfoChip(
                icon: Icons.schedule_rounded,
                label: context.l10n.runtime(movie.runtimeMinutes!),
              ),
            _InfoChip(
              icon: Icons.star_rounded,
              label: movie.voteAverage > 0
                  ? '${HumanFormats.rating(movie.voteAverage, Localizations.localeOf(context).toString())} / 10'
                  : context.l10n.unrated,
              accent: AppColors.amber,
            ),
            _InfoChip(
              icon: Icons.verified_user_outlined,
              label: regionalRelease.when(
                data: (value) => HumanFormats.certification(
                    value.certification, region.code,
                    unavailable: context.l10n.noCertification),
                loading: () => context.l10n.loadingCertification,
                error: (error, stackTrace) => context.l10n.noCertification,
              ),
            ),
          ],
        ),
        if (movie.genreIds.isNotEmpty) ...[
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genreIds
                .where((genre) => genre.trim().isNotEmpty)
                .map((genre) => Chip(
                      label: Text(genre),
                      side: BorderSide.none,
                      backgroundColor: AppColors.card,
                      labelStyle:
                          const TextStyle(color: AppColors.secondaryText),
                    ))
                .toList(),
          ),
        ],
        const SizedBox(height: 28),
        Text(context.l10n.synopsis,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(
          movie.overview.trim().isEmpty
              ? context.l10n.noSynopsis
              : movie.overview,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.secondaryText,
            height: 1.65,
          ),
        ),
        if (actors.isNotEmpty) ...[
          const SizedBox(height: 32),
          Text(context.l10n.cast,
              style:
                  textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          SizedBox(
            height: 232,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: actors.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final actor = actors[index];
                return SizedBox(
                  width: 132,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 0.78,
                          child: actor.profilePath.isEmpty
                              ? const ColoredBox(
                                  color: AppColors.surface,
                                  child: Icon(Icons.person_outline_rounded,
                                      color: AppColors.secondaryText, size: 38),
                                )
                              : Image.network(
                                  actor.profilePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const ColoredBox(
                                    color: AppColors.surface,
                                    child: Icon(Icons.person_outline_rounded,
                                        color: AppColors.secondaryText,
                                        size: 38),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(actor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      Text(actor.character ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall
                              ?.copyWith(color: AppColors.secondaryText)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.accent = AppColors.cyan,
  });

  final IconData icon;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: accent),
            const SizedBox(width: 7),
            Flexible(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
          ],
        ),
      );
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
        .watch(favoriteMoviesProvider)
        .any((favorite) => favorite.id == movie.id);
    return IconButton.filledTonal(
      tooltip:
          isFavorite ? context.l10n.removeFavorite : context.l10n.addFavorite,
      onPressed: () => toggleFavorite(context, ref, movie),
      icon: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
      style: IconButton.styleFrom(
        foregroundColor: isFavorite ? AppColors.cyan : Colors.white,
        backgroundColor: Colors.black45,
      ),
    );
  }
}
