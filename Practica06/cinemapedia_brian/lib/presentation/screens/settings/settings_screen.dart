import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  static const name = 'settings-screen';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRegion = ref.watch(selectedRegionProvider);
    return Scaffold(
      drawer: const CinemapediaDrawer(),
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Configuración'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Abrir menú',
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 2 : 1;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('País e idioma',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 7),
                        Text(
                          'Elige la región para consultar estrenos y títulos localizados.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 34),
                  sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 92,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: CinemaRegion.all.length,
                    itemBuilder: (context, index) {
                      final region = CinemaRegion.all[index];
                      return _RegionTile(
                        region: region,
                        selected: selectedRegion.code == region.code,
                        onTap: () => _selectRegion(context, ref, region),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _selectRegion(
    BuildContext context,
    WidgetRef ref,
    CinemaRegion region,
  ) async {
    try {
      await ref.read(selectedRegionProvider.notifier).select(region);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Región actualizada: ${region.label}'),
          duration: const Duration(seconds: 2),
        ));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No se pudo guardar la región en este dispositivo.'),
      ));
    }
  }
}

class _RegionTile extends StatelessWidget {
  const _RegionTile({
    required this.region,
    required this.selected,
    required this.onTap,
  });

  final CinemaRegion region;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.cyan.withValues(alpha: 0.09)
              : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.cyan
                : Colors.white.withValues(alpha: 0.06),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.08),
                    blurRadius: 18,
                  ),
                ]
              : const [],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(region.flag, style: const TextStyle(fontSize: 29)),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    '${region.countryName} (${region.languageName})',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight:
                              selected ? FontWeight.w800 : FontWeight.w600,
                          color:
                              selected ? Colors.white : AppColors.secondaryText,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    key: ValueKey(selected),
                    color: selected ? AppColors.cyan : AppColors.secondaryText,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
