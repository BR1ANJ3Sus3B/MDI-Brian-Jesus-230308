import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/widgets/movies/movie_poster_card.dart';
import 'package:flutter/material.dart';

class MovieHorizontalListview extends StatefulWidget {
  const MovieHorizontalListview({
    super.key,
    required this.movies,
    this.title,
    this.subTitle,
    this.loadNextPage,
    this.onSeeAll,
  });

  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;
  final VoidCallback? onSeeAll;

  @override
  State<MovieHorizontalListview> createState() =>
      _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {
  final _scrollController = ScrollController();
  bool _requestInProgress = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreWhenNearEnd);
  }

  void _loadMoreWhenNearEnd() {
    if (!mounted ||
        _requestInProgress ||
        widget.loadNextPage == null ||
        !_scrollController.hasClients) {
      return;
    }
    if (_scrollController.position.extentAfter < 260) {
      _requestInProgress = true;
      widget.loadNextPage!();
      Future<void>.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _requestInProgress = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreWhenNearEnd)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies =
        {for (final movie in widget.movies) movie.id: movie}.values.toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth =
        (screenWidth >= 1100 ? 178.0 : 148.0).clamp(118.0, 190.0).toDouble();

    return Padding(
      padding: const EdgeInsets.only(top: 27),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        if (widget.subTitle != null)
                          Text(widget.subTitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.secondaryText)),
                      ],
                    ),
                  ),
                  if (widget.onSeeAll != null)
                    TextButton(
                      onPressed: widget.onSeeAll,
                      child: const Text('Ver todas'),
                    ),
                ],
              ),
            ),
          if (movies.isEmpty)
            const SizedBox(
              height: 270,
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.cyan),
              ),
            )
          else
            SizedBox(
              height: cardWidth * 1.5 + 94,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: movies.length,
                separatorBuilder: (context, index) => const SizedBox(width: 13),
                itemBuilder: (context, index) => MoviePosterCard(
                  movie: movies[index],
                  width: cardWidth,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
