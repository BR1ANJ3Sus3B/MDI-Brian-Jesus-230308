import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          builder: (context, state) =>
              MovieScreen(movieId: state.params['id'] ?? 'no-id'),
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      name: FavoritesScreen.name,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: CategoriesScreen.name,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/collection/:type',
      builder: (context, state) =>
          MovieCollectionScreen(type: state.params['type'] ?? ''),
    ),
    GoRoute(
      path: '/settings',
      name: SettingsScreen.name,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
