import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:widgets_app/config/menu/menu_items.dart';

class SideMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) => NavigationDrawer(
        selectedIndex: _selectedIndex(GoRouterState.of(context).uri.path),
        onDestinationSelected: (value) {
          final link = value == 0 ? '/' : appMenuItems[value - 1].link;
          scaffoldKey.currentState?.closeDrawer();
          context.go(link);
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 28, 16, 16),
            child: Text('Flutter Widgets', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
          ),
          const NavigationDrawerDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: Text('Home')),
          ...appMenuItems.map((item) => NavigationDrawerDestination(icon: Icon(item.icon), label: Text(item.title))),
        ],
      );

  int _selectedIndex(String path) {
    if (path == '/') return 0;
    final itemIndex = appMenuItems.indexWhere((item) => item.link == path);
    return itemIndex < 0 ? 0 : itemIndex + 1;
  }
}
