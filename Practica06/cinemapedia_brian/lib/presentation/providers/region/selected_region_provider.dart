import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedRegionProvider =
    StateNotifierProvider<SelectedRegionNotifier, CinemaRegion>((ref) {
  return SelectedRegionNotifier();
});

final regionTransitionProvider = StateProvider<bool>((ref) => false);

final regionPreferencesReadyProvider = FutureProvider<void>((ref) async {
  await ref.read(selectedRegionProvider.notifier).ready;
});

class SelectedRegionNotifier extends StateNotifier<CinemaRegion> {
  static const _storageKey = 'cinemapedia.region.v1';

  late final Future<void> ready;

  CinemaRegion get current => state;

  SelectedRegionNotifier() : super(CinemaRegion.mexico) {
    ready = _load();
  }

  Future<void> _load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (mounted)
        state = CinemaRegion.fromCode(preferences.getString(_storageKey));
    } catch (_) {
      if (mounted) state = CinemaRegion.mexico;
    }
  }

  Future<void> select(CinemaRegion region) async {
    await ready;
    if (!mounted) return;
    if (state.code == region.code) return;
    state = region;
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(_storageKey, region.code);
    if (!saved) throw StateError('No se pudo guardar el país seleccionado.');
  }
}
