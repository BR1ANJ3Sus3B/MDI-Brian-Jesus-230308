import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's choice for the optional local intro track. No track is
/// bundled yet, so this deliberately controls no playback until an authorized
/// asset is supplied.
final splashSoundEnabledProvider =
    StateNotifierProvider<SplashSoundNotifier, bool>(
        (ref) => SplashSoundNotifier());

class SplashSoundNotifier extends StateNotifier<bool> {
  SplashSoundNotifier() : super(true) {
    _load();
  }

  static const _key = 'cinemapedia.splash-sound.v1';

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    if (mounted) state = preferences.getBool(_key) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, enabled);
  }
}
