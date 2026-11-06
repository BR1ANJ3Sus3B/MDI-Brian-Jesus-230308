import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_horizontal_listview.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1000;
          const content = _HomeView();
          if (!wide) {
            return Scaffold(
              drawer: const CinemapediaDrawer(),
              body: content,
              bottomNavigationBar: CustomBottomNavigation(
                selectedIndex: 0,
                onDestinationSelected: (index) => _navigate(context, index),
              ),
            );
          }
          return Scaffold(
            drawer: const CinemapediaDrawer(),
            body: Row(
              children: [
                CustomBottomNavigation.rail(
                  selectedIndex: 0,
                  onDestinationSelected: (index) => _navigate(context, index),
                ),
                const VerticalDivider(width: 1),
                const Expanded(child: content),
              ],
            ),
          );
        },
      );

  static void _navigate(BuildContext context, int index) {
    if (index == 2) {
      context.go('/favorites');
    } else if (index == 1) {
      context.go('/categories');
    }
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slideShowMovies = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final sectionErrors = ref.watch(movieSectionErrorsProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: const CustomAppbar(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 17),
                    child: Text('Historias que te van a encantar',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.secondaryText,
                                  fontWeight: FontWeight.w600,
                                )),
                  ),
                  if (sectionErrors.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: AppColors.amber),
                            const SizedBox(width: 10),
                            const Expanded(
                                child: Text(
                                    'Algunas colecciones no están disponibles.')),
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(nowPlayingMoviesProvider.notifier)
                                    .loadNextPage();
                                ref
                                    .read(popularMoviesProvider.notifier)
                                    .loadNextPage();
                                ref
                                    .read(upcomingMoviesProvider.notifier)
                                    .loadNextPage();
                                ref
                                    .read(topRatedMoviesProvider.notifier)
                                    .loadNextPage();
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  MoviesSlideshow(movies: slideShowMovies),
                  if (nowPlayingMovies.isNotEmpty)
                    MovieHorizontalListview(
                      movies: nowPlayingMovies,
                      title: 'En cines',
                      subTitle: 'Lo que está en cartelera',
                      onSeeAll: () => context.push('/collection/now-playing'),
                      loadNextPage: () => ref
                          .read(nowPlayingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                  if (upcomingMovies.isNotEmpty)
                    MovieHorizontalListview(
                      movies: upcomingMovies,
                      title: 'Próximamente',
                      subTitle: 'Próximos estrenos',
                      onSeeAll: () => context.push('/collection/upcoming'),
                      loadNextPage: () => ref
                          .read(upcomingMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                  if (popularMovies.isNotEmpty)
                    MovieHorizontalListview(
                      movies: popularMovies,
                      title: 'Populares',
                      subTitle: 'Las más vistas ahora',
                      onSeeAll: () => context.push('/collection/popular'),
                      loadNextPage: () => ref
                          .read(popularMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                  if (topRatedMovies.isNotEmpty)
                    MovieHorizontalListview(
                      movies: topRatedMovies,
                      title: 'Mejor calificadas',
                      subTitle: 'Favoritas de la audiencia',
                      onSeeAll: () => context.push('/collection/top-rated'),
                      loadNextPage: () => ref
                          .read(topRatedMoviesProvider.notifier)
                          .loadNextPage(),
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
