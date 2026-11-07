import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_bottom_navigation.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  static const name = 'categories-screen';

  const CategoriesScreen({super.key});

  static List<(String, String, String, IconData, Color)> _collections(
          BuildContext context) =>
      [
        (
          'now-playing',
          context.l10n.inTheaters,
          context.l10n.nowPlayingDescription,
          Icons.local_movies_rounded,
          AppColors.cyan,
        ),
        (
          'upcoming',
          context.l10n.comingSoon,
          context.l10n.upcomingDescription,
          Icons.upcoming_rounded,
          AppColors.purple,
        ),
        (
          'popular',
          context.l10n.popular,
          context.l10n.popularDescription,
          Icons.trending_up_rounded,
          AppColors.amber,
        ),
        (
          'top-rated',
          context.l10n.topRated,
          context.l10n.topRatedDescription,
          Icons.star_rounded,
          AppColors.cyan,
        ),
      ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1000;
          final content = CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 36, 24, 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                tooltip: context.l10n.backHome,
                                onPressed: () => context.go('/'),
                                icon: const Icon(Icons.arrow_back_rounded),
                              ),
                              const Spacer(),
                              Builder(
                                builder: (scaffoldContext) => IconButton(
                                  tooltip: context.l10n.openMenu,
                                  onPressed: () =>
                                      Scaffold.of(scaffoldContext).openDrawer(),
                                  icon: const Icon(Icons.menu_rounded),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(context.l10n.exploreCategories,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.categoriesDescription,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent >= 760 ? 2 : 1;
                    return SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisExtent: 140 *
                            MediaQuery.textScalerOf(context).scale(14) /
                            14,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _collections(context).length,
                      itemBuilder: (context, index) {
                        final category = _collections(context)[index];
                        return _CategoryTile(
                          title: category.$2,
                          description: category.$3,
                          icon: category.$4,
                          color: category.$5,
                          onTap: () =>
                              context.push('/collection/${category.$1}'),
                        );
                      },
                    );
                  },
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
                    context: context,
                    selectedIndex: 1,
                    onDestinationSelected: (index) => _navigate(context, index),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: content),
                ],
              ),
            );
          }
          return Scaffold(
            drawer: const CinemapediaDrawer(),
            body: content,
            bottomNavigationBar: CustomBottomNavigation(
              selectedIndex: 1,
              onDestinationSelected: (index) => _navigate(context, index),
            ),
          );
        },
      );

  void _navigate(BuildContext context, int index) {
    if (index == 0) context.go('/');
    if (index == 2) context.go('/favorites');
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        color: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text(description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.secondaryText)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: AppColors.secondaryText),
              ],
            ),
          ),
        ),
      );
}
