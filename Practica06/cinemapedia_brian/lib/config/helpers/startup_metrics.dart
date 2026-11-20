import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Profile-mode milestones for the Dart/Flutter portion of startup.
abstract final class StartupMetrics {
  static final Stopwatch _clock = Stopwatch();

  static void start() {
    if (!kProfileMode) return;
    _clock
      ..reset()
      ..start();
    _mark('dart_bootstrap');
  }

  static void mark(String phase) {
    if (kProfileMode) _mark(phase);
  }

  static void _mark(String phase) {
    final elapsedMs = _clock.elapsedMilliseconds;
    developer.Timeline.instantSync('cinemapedia_startup',
        arguments: {'phase': phase, 'elapsedMs': elapsedMs});
    debugPrint('[startup] $phase ${elapsedMs}ms');
  }
}
