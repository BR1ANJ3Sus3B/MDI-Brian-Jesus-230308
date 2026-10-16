import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'package:practica04_brian/config/theme/theme_preset.dart';

class ThemeProvider extends ChangeNotifier {
  ThemePreset _preset = ThemePreset.toktik;
  bool _ready = false;

  ThemePreset get preset => _preset;
  bool get ready => _ready;

  ThemeProvider() {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final data = await Localstore.instance.collection('settings').doc('theme').get();
      final value = data?['preset'] as String?;
      _preset = ThemePreset.values.firstWhere(
        (item) => item.name == value,
        orElse: () => ThemePreset.toktik,
      );
    } catch (_) {
      _preset = ThemePreset.toktik;
    } finally {
      _ready = true;
      notifyListeners();
    }
  }

  Future<void> setPreset(ThemePreset preset) async {
    if (_preset == preset) return;
    _preset = preset;
    notifyListeners();
    try {
      await Localstore.instance.collection('settings').doc('theme').set({
        'preset': preset.name,
      });
    } catch (error) {
      debugPrint('No se pudo guardar el modo visual: $error');
    }
  }
}
