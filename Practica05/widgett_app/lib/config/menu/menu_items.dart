import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;
  const MenuItem({required this.title, required this.subTitle, required this.link, required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(title: 'Theme Changer', subTitle: 'Color y modo oscuro', link: '/theme-changer', icon: Icons.palette_outlined),
  MenuItem(title: 'Buttons', subTitle: 'Botones de Material 3', link: '/buttons', icon: Icons.smart_button_outlined),
  MenuItem(title: 'Cards', subTitle: 'Imagenes y elevaciones', link: '/cards', icon: Icons.credit_card_outlined),
  MenuItem(title: 'Progress Indicators', subTitle: 'Progreso animado', link: '/progress', icon: Icons.donut_large_outlined),
  MenuItem(title: 'Snackbars & Dialogs', subTitle: 'Mensajes y dialogos', link: '/snackbars', icon: Icons.chat_bubble_outline),
  MenuItem(title: 'Animated Container', subTitle: 'Animaciones implicitas', link: '/animated-container', icon: Icons.animation_outlined),
  MenuItem(title: 'Counter Screen', subTitle: 'Estado reactivo', link: '/counter', icon: Icons.add_circle_outline),
];
