import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompact = MediaQuery.sizeOf(context).width < 520;
    final region = ref.watch(selectedRegionProvider);
    return Padding(
      padding:
          EdgeInsets.fromLTRB(isCompact ? 20 : 34, 18, isCompact ? 16 : 34, 18),
      child: Row(
        children: [
          Builder(
            builder: (scaffoldContext) => IconButton(
              tooltip: 'Abrir menú',
              onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: const LinearGradient(
                colors: [AppColors.cyan, AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.local_movies_rounded,
                color: AppColors.background),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cinemapedia',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        )),
                if (!isCompact)
                  Text(
                      '${region.flag} ${region.countryName} · Tu próxima historia empieza aquí',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondaryText,
                          )),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Buscar películas',
            onPressed: () {
              final searchedMovies = ref.read(searchedMoviesProvider);
              final searchQuery = ref.read(searchQueryProvider);
              showSearch<Movie?>(
                query: searchQuery,
                context: context,
                delegate: SearchMovieDelegate(
                  initialMovies: searchedMovies,
                  searchMovies: ref
                      .read(searchedMoviesProvider.notifier)
                      .searchMoviesByQuery,
                ),
              ).then((movie) {
                if (movie == null || !context.mounted) return;
                context.push('/movie/${movie.id}');
              });
            },
            icon: const Icon(Icons.search_rounded),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            tooltip: 'Favoritos',
            onPressed: () => context.push('/favorites'),
            icon: const Icon(Icons.favorite_rounded),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.cyan,
              backgroundColor: AppColors.cyan.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
