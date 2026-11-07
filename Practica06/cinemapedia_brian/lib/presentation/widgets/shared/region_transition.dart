import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/providers/region/selected_region_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Keeps the router mounted while the new regional providers load independently.
class RegionTransition extends ConsumerWidget {
  const RegionTransition({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changing = ref.watch(regionTransitionProvider);
    final region = ref.watch(selectedRegionProvider);
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedOpacity(
          opacity: changing && !reduced ? 0.3 : 1,
          duration: reduced ? Duration.zero : const Duration(milliseconds: 200),
          child: child,
        ),
        // Ignore outgoing overlay hit targets as soon as the transition ends.
        IgnorePointer(
          ignoring: !changing,
          child: AnimatedSwitcher(
            duration:
                reduced ? Duration.zero : const Duration(milliseconds: 200),
            child: !changing
                ? const SizedBox.shrink()
                : Material(
                    key: ValueKey('region-transition-${region.code}'),
                    color: AppColors.background.withValues(alpha: 0.92),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Semantics(
                          liveRegion: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.public_rounded,
                                  color: AppColors.cyan, size: 40),
                              const SizedBox(height: 16),
                              Text(region.flag,
                                  style: const TextStyle(fontSize: 64)),
                              const SizedBox(height: 16),
                              Text(region.localizedCountry(context.l10n),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              Text(
                                  context.l10n.configuringRegion(
                                      region.localizedCountry(context.l10n)),
                                  textAlign: TextAlign.center),
                              if (!reduced) ...[
                                const SizedBox(height: 24),
                                CircularProgressIndicator(
                                    semanticsLabel: context.l10n.loading),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
