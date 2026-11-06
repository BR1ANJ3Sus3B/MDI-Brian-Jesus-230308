import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends ConsumerWidget {
  static const name = 'favorites-screen';

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(favoriteMoviesProvider);
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 1000;
      final body = CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Volver',
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mi lista',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w900)),
                            Text('${movies.length} títulos guardados',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.secondaryText)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.favorite_rounded,
                              color: AppColors.cyan, size: 27),
                          const SizedBox(width: 6),
                          Builder(
                            builder: (scaffoldContext) => IconButton(
                              tooltip: 'Abrir menú',
                              onPressed: () =>
                                  Scaffold.of(scaffoldContext).openDrawer(),
                              icon: const Icon(Icons.menu_rounded),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (movies.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_border_rounded,
                            size: 42, color: AppColors.cyan),
                      ),
                      const SizedBox(height: 20),
                      Text('Tu lista empieza aquí',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                        'Guarda las películas que quieras ver y las encontrarás aquí.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.secondaryText),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.explore_outlined),
                        label: const Text('Explorar películas'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
              sliver: SliverGrid.builder(
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
        ],
      );

      if (wide) {
        return Scaffold(
          drawer: const CinemapediaDrawer(),
          body: Row(
            children: [
              CustomBottomNavigation.rail(
                selectedIndex: 2,
                onDestinationSelected: (index) => _navigate(context, index),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      }
      return Scaffold(
        drawer: const CinemapediaDrawer(),
        body: body,
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: 2,
          onDestinationSelected: (index) => _navigate(context, index),
        ),
      );
    });
  }

  void _navigate(BuildContext context, int index) {
    if (index == 0) context.go('/');
    if (index == 1) context.go('/categories');
  }
}
