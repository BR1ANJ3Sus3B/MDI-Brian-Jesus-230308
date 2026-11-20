import 'dart:async';
import 'package:cinemapedia/l10n/l10n.dart';

import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
    required String searchLabel,
  }) : super(searchFieldLabel: searchLabel);

  final SearchMoviesCallback searchMovies;
  final List<Movie> initialMovies;
  final StreamController<_SearchState> _results =
      StreamController<_SearchState>.broadcast();
  Timer? _debounce;
  String? _scheduledQuery;
  bool _closed = false;
  late _SearchState _currentState = _SearchState(results: initialMovies);

  void _emit(_SearchState state) {
    _currentState = state;
    if (!_closed) _results.add(state);
  }

  void _search(String value) {
    if (_scheduledQuery == value || _closed) return;
    _scheduledQuery = value;
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _emit(const _SearchState(results: []));
      return;
    }

    _emit(const _SearchState(results: [], loading: true));
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final movies = await searchMovies(value.trim());
        if (!_closed && _scheduledQuery == value) {
          _emit(_SearchState(results: _uniqueMovies(movies)));
        }
      } catch (_) {
        if (!_closed && _scheduledQuery == value) {
          _emit(const _SearchState(
            results: [],
            error: 'connection',
          ));
        }
      }
    });
  }

  List<Movie> _uniqueMovies(Iterable<Movie> movies) => {
        for (final movie in movies) movie.id: movie,
      }.values.toList(growable: false);

  void _closeStreams() {
    if (_closed) return;
    _closed = true;
    _debounce?.cancel();
    _results.close();
  }

  @override
  void close(BuildContext context, Movie? result) {
    _closeStreams();
    super.close(context, result);
  }

  Widget _buildResults(BuildContext context) => StreamBuilder<_SearchState>(
        stream: _results.stream,
        initialData: _currentState,
        builder: (context, snapshot) {
          final state = snapshot.data ?? const _SearchState(results: []);
          if (state.loading) {
            return const LinearProgressIndicator(
                minHeight: 2, color: AppColors.cyan);
          }
          if (state.error != null) {
            return _SearchMessage(
                icon: Icons.wifi_off_rounded,
                message: context.l10n.connectionError,
                onRetry: () {
                  _scheduledQuery = null;
                  _search(query);
                });
          }
          if (state.results.isEmpty) {
            return _SearchMessage(
              icon: Icons.search_rounded,
              message: query.trim().isEmpty
                  ? context.l10n.searchHint
                  : context.l10n.noResults(query.trim()),
            );
          }

          final width = MediaQuery.sizeOf(context).width;
          final cardWidth = width >= 900 ? 180.0 : 148.0;
          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(18),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: cardWidth + 18,
                mainAxisExtent: cardWidth * 1.5 + 94,
                crossAxisSpacing: 14,
                mainAxisSpacing: 16,
              ),
              itemCount: state.results.length,
              itemBuilder: (context, index) => LayoutBuilder(
                builder: (context, constraints) => MoviePosterCard(
                  movie: state.results[index],
                  width: constraints.maxWidth,
                ),
              ),
            ),
          );
        },
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            tooltip: context.l10n.clearSearch,
            onPressed: () {
              query = '';
              _search('');
            },
            icon: const Icon(Icons.close_rounded),
          ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        tooltip: context.l10n.back,
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_rounded),
      );

  @override
  Widget buildResults(BuildContext context) {
    _search(query);
    return Column(children: [_buildResults(context)]);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _search(query);
    return Column(children: [_buildResults(context)]);
  }
}

class _SearchState {
  const _SearchState({
    required this.results,
    this.loading = false,
    this.error,
  });

  final List<Movie> results;
  final bool loading;
  final String? error;
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage(
      {required this.icon, required this.message, this.onRetry});
  final VoidCallback? onRetry;

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 46, color: AppColors.secondaryText),
                const SizedBox(height: 13),
                if (onRetry != null)
                  TextButton(
                      onPressed: onRetry, child: Text(context.l10n.retry)),
                Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: AppColors.secondaryText)),
              ],
            ),
          ),
        ),
      );
}
