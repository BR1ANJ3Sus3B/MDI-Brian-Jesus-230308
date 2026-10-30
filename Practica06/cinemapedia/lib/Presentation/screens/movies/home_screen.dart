import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _HomeView());
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final moviesState = ref.watch(nowPlayingMoviesProvider);

    if (moviesState.isLoading && moviesState.movies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (moviesState.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(moviesState.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (moviesState.movies.isEmpty) {
      return const Center(child: Text('No hay películas disponibles.'));
    }

    return ListView.builder(
      itemCount: moviesState.movies.length,
      itemBuilder: (context, index) {
        final movie = moviesState.movies[index];
        return ListTile(title: Text(movie.title));
      },
    );
  }
}
