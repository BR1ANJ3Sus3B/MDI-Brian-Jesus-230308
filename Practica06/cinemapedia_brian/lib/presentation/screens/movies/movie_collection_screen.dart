import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieCollectionScreen extends ConsumerStatefulWidget {
  const MovieCollectionScreen({super.key, required this.type});

  final String type;

  @override
  ConsumerState<MovieCollectionScreen> createState() =>
      _MovieCollectionScreenState();
}

class _MovieCollectionScreenState extends ConsumerState<MovieCollectionScreen> {
  bool _requested = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    if (_requested || !mounted) return;
    _requested = true;
    await ref.read(regionPreferencesReadyProvider.future);
    if (!mounted) return;
    switch (widget.type) {
      case 'now-playing':
        ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
        break;
      case 'upcoming':
        ref.read(upcomingMoviesProvider.notifier).loadNextPage();
        break;
      case 'popular':
        ref.read(popularMoviesProvider.notifier).loadNextPage();
        break;
      case 'top-rated':
        ref.read(topRatedMoviesProvider.notifier).loadNextPage();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movies = _movies();
    final title = _title();
    final error = ref.watch(movieSectionErrorsProvider)[_errorKey()];
    final loaded = ref.watch(loadedMovieSectionsProvider).contains(_errorKey());
    return Scaffold(
      drawer: const CinemapediaDrawer(),
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.l10n.backCategories,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
        actions: [
          Builder(
            builder: (scaffoldContext) => IconButton(
              tooltip: context.l10n.openMenu,
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: movies.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    error == null
                        ? Icons.local_movies_outlined
                        : Icons.wifi_off_rounded,
                    size: 42,
                    color: AppColors.secondaryText,
                  ),
                  const SizedBox(height: 14),
                  Text(
                      error != null
                          ? context.l10n.collectionError
                          : loaded
                              ? context.l10n.emptyMovies
                              : context.l10n.loadingCollection(title),
                      textAlign: TextAlign.center),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(context.l10n.retry),
                    ),
                  ] else if (!loaded) ...[
                    const SizedBox(height: 12),
                    const CircularProgressIndicator(color: AppColors.cyan),
                  ],
                ],
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: GridView.builder(
                  padding: const EdgeInsets.all(22),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 365,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) => LayoutBuilder(
                    builder: (context, constraints) => MoviePosterCard(
                      movie: movies[index],
                      width: constraints.maxWidth,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  List<Movie> _movies() => switch (widget.type) {
        'now-playing' => ref.watch(nowPlayingMoviesProvider),
        'upcoming' => ref.watch(upcomingMoviesProvider),
        'popular' => ref.watch(popularMoviesProvider),
        'top-rated' => ref.watch(topRatedMoviesProvider),
        _ => const [],
      };

  String _title() => switch (widget.type) {
        'now-playing' => context.l10n.inTheaters,
        'upcoming' => context.l10n.comingSoon,
        'popular' => context.l10n.popular,
        'top-rated' => context.l10n.topRated,
        _ => context.l10n.movies,
      };

  void _retry() {
    final errors = {...ref.read(movieSectionErrorsProvider)}
      ..remove(_errorKey());
    ref.read(movieSectionErrorsProvider.notifier).state = errors;
    _requested = false;
    setState(() {});
    _load();
  }

  String _errorKey() => switch (widget.type) {
        'now-playing' => 'nowPlaying',
        'top-rated' => 'topRated',
        'upcoming' => 'upcoming',
        'popular' => 'popular',
        _ => widget.type,
      };
}
