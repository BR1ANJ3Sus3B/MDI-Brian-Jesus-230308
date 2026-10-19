import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_scrollable_view.dart';
import 'package:provider/provider.dart';

class _Repo implements VideoRepository {
  @override
  Future<List<VideoPost>> getVideosByPage(int page) async => const [];
}

List<VideoPost> _videos() => List<VideoPost>.generate(
  4,
  (int i) => VideoPost(
    caption: 'Publicacion $i con un texto largo de dos lineas',
    userName: 'autor${i + 1}',
    songName: 'un audio con nombre largo',
    videoUrl: 'assets/videos/${i + 1}.mp4',
    likes: 23000 + i,
    views: 1500,
  ),
);

/// `VideoButtons` trae una animacion infinita (`SpinPerfect`) y el reproductor
/// intenta cargar un asset real, asi que en pruebas se envuelve todo en
/// `TickerMode` (para los tickers) y se avanza el reloj con [_tick] (para el
/// `Future.delayed` con el que `animate_do` arranca la animacion).
Widget _wrap({
  required List<VideoPost> videos,
  bool isLoadingMore = false,
  bool hasReachedEnd = false,
}) => MaterialApp(
  home: ChangeNotifierProvider<DiscoverProvider>(
    create: (_) => DiscoverProvider(_Repo()),
    child: TickerMode(
      enabled: false,
      child: VideoScrollableView(
        videos: videos,
        isLoadingMore: isLoadingMore,
        hasReachedEnd: hasReachedEnd,
      ),
    ),
  ),
);

Future<void> _tick(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  group('VideoScrollableView', () {
    testWidgets('renderiza el feed sin desbordar el layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videos: _videos()));
      await _tick(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('Siguiendo'), findsOneWidget);
      expect(find.text('Para ti'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('el header se dibuja por encima del video', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videos: _videos()));
      await _tick(tester);

      // El reproductor queda detras: el header sigue siendo visible.
      expect(find.text('Para ti'), findsOneWidget);
    });

    testWidgets('muestra las acciones de cada video', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videos: _videos()));
      await _tick(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.ios_share), findsOneWidget);
    });

    testWidgets('avisa cuando se esta cargando otra pagina', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(videos: _videos(), isLoadingMore: true),
      );
      await _tick(tester);

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('avisa cuando se acabaron los videos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(videos: _videos(), hasReachedEnd: true),
      );
      await _tick(tester);

      expect(find.text('Has visto todos los videos'), findsOneWidget);
    });

    testWidgets('el cambio de pestana no rompe el feed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videos: _videos()));
      await _tick(tester);

      await tester.tap(find.text('Siguiendo'));
      await _tick(tester);

      expect(tester.takeException(), isNull);
    });
  });
}