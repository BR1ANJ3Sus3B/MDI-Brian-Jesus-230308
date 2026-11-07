import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static List<NavigationDestination> _destinations(BuildContext context) => [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home_rounded),
          label: context.l10n.home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.category_outlined),
          selectedIcon: const Icon(Icons.category_rounded),
          label: context.l10n.categories,
        ),
        NavigationDestination(
          icon: const Icon(Icons.favorite_border_rounded),
          selectedIcon: const Icon(Icons.favorite_rounded),
          label: context.l10n.favorites,
        ),
      ];

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: _destinations(context),
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  static Widget rail({
    required BuildContext context,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
  }) =>
      NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        labelType: NavigationRailLabelType.all,
        backgroundColor: AppColors.surface,
        selectedIconTheme: const IconThemeData(color: AppColors.cyan),
        selectedLabelTextStyle: const TextStyle(
          color: AppColors.cyan,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle:
            const TextStyle(color: AppColors.secondaryText),
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home_rounded),
            label: Text(context.l10n.home),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category_rounded),
            label: Text(context.l10n.categories),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.favorite_border_rounded),
            selectedIcon: const Icon(Icons.favorite_rounded),
            label: Text(context.l10n.favorites),
          ),
        ],
      );
}
