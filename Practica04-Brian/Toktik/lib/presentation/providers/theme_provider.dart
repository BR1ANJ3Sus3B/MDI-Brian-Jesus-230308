import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:localstore/localstore.dart';
import 'package:practica04_brian/config/theme/theme_preset.dart';

class ThemeProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Completer<void> _restoreCompleter = Completer<void>();
  ThemePreset _preset = ThemePreset.toktik;
  bool _ready = false;
  bool _musicPlaying = false;
  String? _musicError;

  ThemePreset get preset => _preset;
  bool get ready => _ready;
  Future<void> get whenReady => _restoreCompleter.future;
  bool get musicPlaying => _musicPlaying;
  String? get musicError => _musicError;
  String get musicTitle => _preset.musicTitle;

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
      if (!_restoreCompleter.isCompleted) _restoreCompleter.complete();
    }
  }

  Future<void> setPreset(ThemePreset preset) async {
    if (_preset == preset) return;
    _preset = preset;
    await stopMusic();
    notifyListeners();
    try {
      await Localstore.instance.collection('settings').doc('theme').set({
        'preset': preset.name,
      });
    } catch (error) {
      debugPrint('No se pudo guardar el modo visual: $error');
    }
  }

  Future<void> toggleMusic() async {
    if (_musicPlaying) {
      await stopMusic();
      return;
    }
    _musicError = null;
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      final assetPath = _preset.musicAssetPath;
      if (assetPath != null) {
        await _audioPlayer.play(AssetSource(assetPath));
      } else {
        await _audioPlayer.play(UrlSource(_preset.musicUrl));
      }
      _musicPlaying = true;
    } catch (error) {
      _musicError = 'No se pudo reproducir ${_preset.musicTitle}.';
      debugPrint('No se pudo reproducir música: $error');
    }
    notifyListeners();
  }

  Future<void> stopMusic() async {
    if (!_musicPlaying) return;
    await _audioPlayer.stop();
    _musicPlaying = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
