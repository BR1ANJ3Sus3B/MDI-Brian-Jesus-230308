import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/widgets/video/fullscreen_player.dart';

class FakePlayer extends VideoPlayerPlatform {
  double volume = -1;
  bool playing = false;
  final events = StreamController<VideoEvent>();
  @override
  Future<void> init() async {}
  @override
  Future<int?> createWithOptions(VideoCreationOptions options) async => 1;
  @override
  Stream<VideoEvent> videoEventsFor(int playerId) {
    events.add(
      VideoEvent(
        eventType: VideoEventType.initialized,
        duration: const Duration(minutes: 1),
        size: const Size(360, 640),
      ),
    );
    return events.stream;
  }

  @override
  Future<void> dispose(int playerId) async {
    await events.close();
  }

  @override
  Future<void> setLooping(int playerId, bool looping) async {}
  @override
  Future<void> play(int playerId) async {
    playing = true;
  }

  @override
  Future<void> pause(int playerId) async {
    playing = false;
  }

  @override
  Future<void> setVolume(int playerId, double volume) async {
    this.volume = volume;
  }

  @override
  Future<void> setPlaybackSpeed(int playerId, double speed) async {}
  @override
  Future<Duration> getPosition(int playerId) async => Duration.zero;
  @override
  Widget buildViewWithOptions(VideoViewOptions options) =>
      const SizedBox.expand();
}

Widget player({bool active = true}) => MaterialApp(
  home: Scaffold(
    body: FullScreenPlayer(
      videoUrl: 'assets/videos/1.mp4',
      caption: 'Video',
      playbackType: VideoPlaybackType.asset,
      platform: VideoPlatform.local,
      isActive: active,
    ),
  ),
);
void main() {
  late FakePlayer platform;
  late VideoPlayerPlatform previous;
  setUp(() {
    previous = VideoPlayerPlatform.instance;
    platform = FakePlayer();
    VideoPlayerPlatform.instance = platform;
  });
  tearDown(() => VideoPlayerPlatform.instance = previous);
  testWidgets('el altavoz silencia y restaura el volumen real', (tester) async {
    await tester.pumpWidget(player());
    await tester.pumpAndSettle();
    expect(platform.volume, 0);
    expect(platform.playing, isTrue);
    await tester.tap(find.byTooltip('Activar sonido'));
    await tester.pump();
    expect(platform.volume, 1);
    await tester.tap(find.byTooltip('Silenciar'));
    await tester.pump();
    expect(platform.volume, 0);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('pausa al perder visibilidad y reanuda al volver', (
    tester,
  ) async {
    await tester.pumpWidget(player());
    await tester.pumpAndSettle();
    expect(platform.playing, isTrue);
    await tester.pumpWidget(player(active: false));
    await tester.pump();
    expect(platform.playing, isFalse);
    await tester.pumpWidget(player());
    await tester.pump();
    expect(platform.playing, isTrue);
    await tester.pumpWidget(const SizedBox());
  });
}
