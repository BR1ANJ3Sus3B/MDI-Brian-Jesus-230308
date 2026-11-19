import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/tv_show.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/providers/tv/tv_shows_providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/tv/tv_show_poster_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TvShowsScreen extends ConsumerStatefulWidget {
  const TvShowsScreen({super.key});
  static const name = 'tv-shows-screen';

  @override
  ConsumerState<TvShowsScreen> createState() => _TvShowsScreenState();
}

class _TvShowsScreenState extends ConsumerState<TvShowsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Future.wait([
        ref.read(onTheAirTvShowsProvider.notifier).loadNextPage(),
        ref.read(popularTvShowsProvider.notifier).loadNextPage(),
        ref.read(topRatedTvShowsProvider.notifier).loadNextPage(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = _TvShowsView(
      onTheAir: ref.watch(onTheAirTvShowsProvider),
      popular: ref.watch(popularTvShowsProvider),
      topRated: ref.watch(topRatedTvShowsProvider),
    );
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 1000;
      if (!wide) {
        return Scaffold(
          drawer: const CinemapediaDrawer(),
          body: content,
          bottomNavigationBar: CustomBottomNavigation(
              selectedIndex: 1, onDestinationSelected: _navigate),
        );
      }
      return Scaffold(
          drawer: const CinemapediaDrawer(),
          body: Row(children: [
            CustomBottomNavigation.rail(
                context: context,
                selectedIndex: 1,
                onDestinationSelected: _navigate),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ]));
    });
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        context.go('/');
      case 2:
        context.go('/categories');
      case 3:
        context.go('/favorites');
    }
  }
}

class _TvShowsView extends StatelessWidget {
  const _TvShowsView(
      {required this.onTheAir, required this.popular, required this.topRated});
  final List<TvShow> onTheAir;
  final List<TvShow> popular;
  final List<TvShow> topRated;

  @override
  Widget build(BuildContext context) => CustomScrollView(slivers: [
        SliverAppBar(
            title: Text(context.l10n.series),
            floating: true,
            actions: [
              Builder(
                  builder: (context) => IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(context).openDrawer())),
            ]),
        SliverToBoxAdapter(
            child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1440),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(22, 10, 22, 0),
                            child: Text(context.l10n.discoverTvShows,
                                style:
                                    TextStyle(color: AppColors.secondaryText))),
                        _ShowRow(title: context.l10n.onTheAir, shows: onTheAir),
                        _ShowRow(
                            title: context.l10n.popularSeries, shows: popular),
                        _ShowRow(
                            title: context.l10n.topRatedSeries,
                            shows: topRated),
                        const SizedBox(height: 40),
                      ]),
                ))),
      ]);
}

class _ShowRow extends StatelessWidget {
  const _ShowRow({required this.title, required this.shows});
  final String title;
  final List<TvShow> shows;
  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.sizeOf(context).width >= 1100 ? 178.0 : 148.0);
    return Padding(
        padding: const EdgeInsets.only(top: 27),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
              child: Row(children: [
                Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                        color: AppColors.cyan,
                        borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 10),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ])),
          SizedBox(
              height: cardWidth * 1.5 + 94,
              child: shows.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.cyan))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      scrollDirection: Axis.horizontal,
                      itemCount: shows.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 13),
                      itemBuilder: (_, index) => TvShowPosterCard(
                          show: shows[index], width: cardWidth))),
        ]));
  }
}
