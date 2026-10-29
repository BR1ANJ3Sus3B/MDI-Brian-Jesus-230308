import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView()
    );
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

    if (Environment.theMovieDbKey.isNotEmpty) {
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    }
  }


  @override
  Widget build(BuildContext context) {

    if (Environment.theMovieDbKey.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Agrega THE_MOVIEDB_KEY en assets/config/.env para cargar películas.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);


    return ListView.builder(
      itemCount: nowPlayingMovies.length,
      itemBuilder: (context, index) {
        final movie = nowPlayingMovies[index];
        return ListTile(
          title: Text( movie.title ),
        );
      },
    );
  }
}
