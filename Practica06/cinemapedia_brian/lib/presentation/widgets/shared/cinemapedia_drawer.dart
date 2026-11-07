import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CinemapediaDrawer extends StatelessWidget {
  const CinemapediaDrawer({super.key});

  static List<_DrawerItem> _items(BuildContext context) => [
        _DrawerItem(context.l10n.home, Icons.home_rounded, '/'),
        _DrawerItem(context.l10n.inTheaters, Icons.local_movies_rounded,
            '/collection/now-playing'),
        _DrawerItem(context.l10n.comingSoon, Icons.upcoming_rounded,
            '/collection/upcoming'),
        _DrawerItem(
            context.l10n.categories, Icons.category_rounded, '/categories'),
        _DrawerItem(
            context.l10n.favorites, Icons.favorite_rounded, '/favorites'),
        _DrawerItem(context.l10n.settings, Icons.settings_rounded, '/settings'),
      ];

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: AppColors.surface,
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [AppColors.cyan, AppColors.purple],
                        ),
                      ),
                      child: const Icon(Icons.local_movies_rounded,
                          color: AppColors.background),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text('Cinemapedia',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                    )))),
                  ],
                ),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              const SizedBox(height: 10),
              for (final item in _items(context))
                ListTile(
                  leading: Icon(item.icon, color: AppColors.secondaryText),
                  title: Text(item.label),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 22),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (item.path == '/settings') {
                      context.push(item.path);
                    } else {
                      context.go(item.path);
                    }
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(context.l10n.drawerTagline,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        )),
              ),
            ],
          ),
        ),
      );
}

class _DrawerItem {
  const _DrawerItem(this.label, this.icon, this.path);

  final String label;
  final IconData icon;
  final String path;
}
