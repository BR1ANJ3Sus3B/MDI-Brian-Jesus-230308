import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';

/// Cabecera superpuesta al video con las pestanas "Siguiendo" / "Para ti" y el
/// boton de busqueda, al estilo de TikTok.
///
/// Solo se dibuja la pestana activa: la inactiva se atenua para indicar que
/// tambien es interactiva (el cambio de pestana queda fuera del alcance de
/// esta practica).
class VideoHeader extends StatelessWidget {
  static const int followingTab = 0;
  static const int forYouTab = 1;

  final int selectedTab;
  final ValueChanged<int>? onTabSelected;

  const VideoHeader({
    super.key,
    this.selectedTab = forYouTab,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Tab(
                    label: 'Siguiendo',
                    isSelected: selectedTab == followingTab,
                    onTap: () => onTabSelected?.call(followingTab),
                  ),
                  _Tab(
                    label: 'Para ti',
                    isSelected: selectedTab == forYouTab,
                    onTap: () => onTabSelected?.call(forYouTab),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Buscar',
              icon: const Icon(Icons.search, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                shadows: const [
                  Shadow(color: Color(0x80000000), blurRadius: 6),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Subrayado: invisible en la pestana inactiva.
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 3,
              width: isSelected ? 32 : 0,
              decoration: BoxDecoration(
                color: AppColors.textPrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}