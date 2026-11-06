import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_regional_release_provider.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MoviesSlideshow extends StatefulWidget {
  const MoviesSlideshow({super.key, required this.movies});

  final List<Movie> movies;

  @override
  State<MoviesSlideshow> createState() => _MoviesSlideshowState();
}

class _MoviesSlideshowState extends State<MoviesSlideshow> {
  final _pageController = PageController(viewportFraction: 0.94);
  int _currentPage = 0;
  bool _animating = false;

  Future<void> _navigateTo(int index) async {
    if (_animating || widget.movies.isEmpty || !_pageController.hasClients) {
      return;
    }
    if (_pageController.position.isScrollingNotifier.value) return;
    final target = index.clamp(0, widget.movies.length - 1);
    if (target == _currentPage) return;
    _animating = true;
    try {
      await _pageController.animateToPage(
        target,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    } finally {
      _animating = false;
    }
  }

  @override
  void didUpdateWidget(covariant MoviesSlideshow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final lastIndex = widget.movies.isEmpty ? 0 : widget.movies.length - 1;
    if (_currentPage > lastIndex || oldWidget.movies.isEmpty) {
      _currentPage = _currentPage.clamp(0, lastIndex);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(_currentPage);
        }
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const _FeaturedLoading();

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 850;
      final height = isWide ? 450.0 : 440.0;
      return Column(
        children: [
          SizedBox(
            height: height,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: PointerDeviceKind.values.toSet(),
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.movies.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: _FeaturedCard(
                    movie: widget.movies[index],
                    isWide: isWide,
                    onPrevious: () => _navigateTo(_currentPage - 1),
                    onNext: () => _navigateTo(_currentPage + 1),
                    onFirst: () => _navigateTo(0),
                    canGoPrevious: _currentPage > 0,
                    canGoNext: _currentPage < widget.movies.length - 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.movies.length, (index) {
              final selected = index == _currentPage;
              return AnimatedContainer(
                key: ValueKey('featured-indicator-$index'),
                duration: const Duration(milliseconds: 220),
                width: selected ? 22 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: selected ? AppColors.cyan : Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}

class _FeaturedCard extends ConsumerWidget {
  const _FeaturedCard({
    required this.movie,
    required this.isWide,
    required this.onPrevious,
    required this.onNext,
    required this.onFirst,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final Movie movie;
  final bool isWide;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFirst;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteMoviesProvider);
    final regionalRelease = ref.watch(movieRegionalReleaseProvider(movie.id));
    final region = ref.watch(selectedRegionProvider);
    final isFavorite = favorites.any((item) => item.id == movie.id);
    final titleIsUnlocalized = movie.title == movie.originalTitle &&
        movie.originalLanguage.toLowerCase() !=
            region.languageCode.split('-').first.toLowerCase();
    final releaseYear = regionalRelease.asData?.value.releaseDate?.year ??
        movie.releaseDate.year;
    final year = releaseYear > 1900 ? releaseYear.toString() : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            movie.backdropPath,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) => const _HeroFallback(),
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : const _HeroFallback(isLoading: true),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xAA080B16), Color(0xF5080B16)],
                stops: [0, 0.95],
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0x408957FF),
                  Colors.transparent,
                  Color(0xAA080B16)
                ],
                stops: [0, 0.42, 1],
              ),
            ),
          ),
          _CarouselNavigation(
            onPrevious: onPrevious,
            onNext: onNext,
            onFirst: onFirst,
            canGoPrevious: canGoPrevious,
            canGoNext: canGoNext,
          ),
          Positioned(
            top: 14,
            right: 74,
            child: IconButton.filledTonal(
              tooltip:
                  isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
              onPressed: () =>
                  ref.read(favoriteMoviesProvider.notifier).toggle(movie),
              icon: Icon(isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.44),
                foregroundColor: isFavorite ? AppColors.cyan : Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(isWide ? 40 : 24, 24, 24, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isWide ? 620 : 540),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            color: AppColors.cyan, size: 17),
                        const SizedBox(width: 6),
                        Text('EN CARTELERA',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: AppColors.cyan,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w800,
                                )),
                      ],
                    ),
                    const SizedBox(height: 11),
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                height: 1.04,
                                fontSize: isWide ? 40 : 31,
                              ),
                    ),
                    if (movie.originalTitle.trim().isNotEmpty &&
                        movie.originalTitle != movie.title) ...[
                      const SizedBox(height: 4),
                      Text(
                        movie.originalTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        if (year != null) _MetaLabel(label: year),
                        _MetaLabel(
                          label: movie.voteAverage > 0
                              ? '★ ${HumanFormats.rating(movie.voteAverage)} / 10'
                              : 'Sin calificación',
                          color: AppColors.amber,
                        ),
                        _MetaLabel(
                          label: regionalRelease.when(
                            data: (value) => HumanFormats.certification(
                                value.certification, region.code),
                            loading: () => 'Consultando clasificación…',
                            error: (error, stackTrace) =>
                                'Sin clasificación disponible',
                          ),
                        ),
                      ],
                    ),
                    if (titleIsUnlocalized) ...[
                      const SizedBox(height: 5),
                      Text(
                        'La API no devolvió título localizado; se muestra el original.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                    if (movie.voteAverage > 0) ...[
                      const SizedBox(height: 7),
                      _RatingStars(rating: movie.voteAverage),
                    ],
                    if (movie.overview.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        movie.overview,
                        maxLines: isWide ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.82),
                              height: 1.4,
                            ),
                      ),
                    ],
                    const SizedBox(height: 17),
                    FilledButton.icon(
                      onPressed: () => context.push('/movie/${movie.id}'),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Ver detalles'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Behind the information and action controls: their own hit targets win.
// One recognizer covers both halves, so a double tap cancels the single tap.
class _CarouselNavigation extends StatefulWidget {
  const _CarouselNavigation({
    required this.onPrevious,
    required this.onNext,
    required this.onFirst,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFirst;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  State<_CarouselNavigation> createState() => _CarouselNavigationState();
}

class _CarouselNavigationState extends State<_CarouselNavigation> {
  bool? _pressedLeft;

  void _release() {
    if (_pressedLeft != null) setState(() => _pressedLeft = null);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTapDown: (details) => setState(() => _pressedLeft =
                details.localPosition.dx < constraints.maxWidth / 2),
            onTapUp: (details) {
              _release();
              if (details.localPosition.dx < constraints.maxWidth / 2) {
                widget.onPrevious();
              } else {
                widget.onNext();
              }
            },
            onTapCancel: _release,
            onDoubleTap: () {
              _release();
              widget.onFirst();
            },
            child: Stack(
              children: [
                _arrow(true),
                _arrow(false),
              ],
            ),
          ),
        ),
      );

  Widget _arrow(bool left) {
    final enabled = left ? widget.canGoPrevious : widget.canGoNext;
    return Positioned(
      top: 14,
      left: left ? 14 : null,
      right: left ? null : 14,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: left ? 'Película anterior' : 'Película siguiente',
        hint: 'Doble toque en la imagen para volver a la primera película',
        onTap: enabled ? (left ? widget.onPrevious : widget.onNext) : null,
        child: AnimatedScale(
          scale: _pressedLeft == left ? 0.9 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.55),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(
              left ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
              color: enabled ? Colors.white : Colors.white54,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaLabel extends StatelessWidget {
  const _MetaLabel({required this.label, this.color = AppColors.secondaryText});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      );
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final stars = rating / 2;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final icon = stars >= index + 1
            ? Icons.star_rounded
            : stars > index + 0.5
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        return Icon(icon, size: 17, color: AppColors.amber);
      }),
    );
  }
}

class _FeaturedLoading extends StatelessWidget {
  const _FeaturedLoading();

  @override
  Widget build(BuildContext context) => Container(
        height: 420,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [AppColors.surface, AppColors.card],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
            child: CircularProgressIndicator(color: AppColors.cyan)),
      );
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback({this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: AppColors.cyan)
              : const Icon(Icons.movie_creation_outlined,
                  size: 56, color: AppColors.secondaryText),
        ),
      );
}
