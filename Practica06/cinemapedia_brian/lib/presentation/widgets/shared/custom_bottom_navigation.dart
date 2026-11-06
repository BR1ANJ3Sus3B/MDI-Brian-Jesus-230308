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

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(Icons.category_outlined),
      selectedIcon: Icon(Icons.category_rounded),
      label: 'Categorías',
    ),
    NavigationDestination(
      icon: Icon(Icons.favorite_border_rounded),
      selectedIcon: Icon(Icons.favorite_rounded),
      label: 'Favoritos',
    ),
  ];

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: _destinations,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  static Widget rail({
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
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: Text('Inicio'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category_rounded),
            label: Text('Categorías'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: Text('Favoritos'),
          ),
        ],
      );
}
