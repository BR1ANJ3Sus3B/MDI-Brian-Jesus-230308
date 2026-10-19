import 'package:flutter/material.dart';
import 'package:practica04_brian/infrastructure/repositories/likes_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/config/helpers/human_formats.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_buttons.dart';

VideoPost _post({int likes = 23230, String userName = 'brain.dev'}) =>
    VideoPost(
      caption: 'Un video',
      videoUrl: 'assets/videos/1.mp4',
      userName: userName,
      songName: 'sonido original',
      likes: likes,
    );

/// `VideoButtons` usa animaciones infinitas de `animate_do` (`SpinPerfect` y
/// `Pulse`). En pruebas hay que:
/// 1. Envolver en `TickerMode(enabled: false)` para que los tickers no queden
///    corriendo, y
/// 2. avanzar el reloj unos milisegundos con [_tick], porque `animate_do`
///    arranca la animacion con un `Future.delayed`: si ese timer no llega a
///    dispararse, el test falla con "A Timer is still pending".
Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: TickerMode(enabled: false, child: child)),
);

/// Avanza el reloj lo justo para que `animate_do` dispare su `Future.delayed`.
/// Se hace dos veces porque al marcar un like se monta la animacion `Pulse`
/// en el frame siguiente al toque, y esa genera su propio timer.
Future<void> _tick(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump(const Duration(milliseconds: 1));
}

class MemoryLikes implements LikesRepository {
  final Map<String, bool> values = {};
  bool failWrites = false;
  @override
  Future<bool> isLiked(VideoPost video) async =>
      values[video.videoUrl] ?? false;
  @override
  Future<void> setLiked(VideoPost video, bool liked) async {
    if (failWrites) throw StateError('storage unavailable');
    values[video.videoUrl] = liked;
  }
}

void main() {
  testWidgets('restaura el like y permite quitarlo sin duplicar el contador', (
    tester,
  ) async {
    final storage = MemoryLikes();
    final video = _post(likes: 10);
    await tester.pumpWidget(
      _wrap(VideoButtons(video: video, likesRepository: storage)),
    );
    await _tick(tester);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await _tick(tester);
    expect(storage.values[video.videoUrl], isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(
      _wrap(VideoButtons(video: video, likesRepository: storage)),
    );
    await _tick(tester);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite));
    await _tick(tester);
    expect(storage.values[video.videoUrl], isFalse);
    expect(find.text('10'), findsOneWidget);
  });
  testWidgets('revierte el like cuando falla el almacenamiento', (
    tester,
  ) async {
    final storage = MemoryLikes()..failWrites = true;
    await tester.pumpWidget(
      _wrap(VideoButtons(video: _post(), likesRepository: storage)),
    );
    await _tick(tester);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await _tick(tester);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(
      find.text('No se pudo guardar el like. Intenta de nuevo.'),
      findsOneWidget,
    );
  });
  group('VideoButtons', () {
    testWidgets('muestra los contadores con formato compacto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          VideoButtons(
            likesRepository: MemoryLikes(),
            video: _post(likes: 23230),
          ),
        ),
      );
      await _tick(tester);

      expect(find.text('23.2K'), findsOneWidget);
    });

    testWidgets('el like alterna entre relleno y contorno', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(VideoButtons(likesRepository: MemoryLikes(), video: _post())),
      );
      await _tick(tester);

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await _tick(tester);

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('el like se puede volver a quitar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(VideoButtons(likesRepository: MemoryLikes(), video: _post())),
      );
      await _tick(tester);

      await tester.tap(find.byIcon(Icons.favorite_border));
      await _tick(tester);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      await tester.tap(find.byIcon(Icons.favorite));
      await _tick(tester);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('el contador del like refleja el valor de la entidad', (
      WidgetTester tester,
    ) async {
      const int likes = 1030;
      await tester.pumpWidget(
        _wrap(
          VideoButtons(
            likesRepository: MemoryLikes(),
            video: _post(likes: likes),
          ),
        ),
      );
      await _tick(tester);

      expect(
        find.text(HumanFormats.humanReadableNumber(likes.toDouble())),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await _tick(tester);

      // Tras el like el contador sube en 1.
      expect(
        find.text(HumanFormats.humanReadableNumber((likes + 1).toDouble())),
        findsOneWidget,
      );
    });

    testWidgets('el avatar muestra la inicial del autor', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(VideoButtons(likesRepository: MemoryLikes(), video: _post())),
      );
      await _tick(tester);

      // "brain.dev" -> "B", tanto en el avatar como en el disco de audio.
      expect(find.text('B'), findsNWidgets(2));
    });

    testWidgets('el avatar normaliza un autor con arroba', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          VideoButtons(
            likesRepository: MemoryLikes(),
            video: _post(userName: '@maria'),
          ),
        ),
      );
      await _tick(tester);

      expect(find.text('M'), findsNWidgets(2));
    });

    testWidgets('el avatar tolera un autor vacio', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          VideoButtons(
            likesRepository: MemoryLikes(),
            video: _post(userName: ''),
          ),
        ),
      );
      await _tick(tester);

      expect(find.text('?'), findsNWidgets(2));
    });

    testWidgets('muestra las demas acciones del video', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(VideoButtons(likesRepository: MemoryLikes(), video: _post())),
      );
      await _tick(tester);

      expect(find.byIcon(Icons.mode_comment_outlined), findsOneWidget);
      expect(find.byIcon(Icons.ios_share), findsOneWidget);
      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });

    testWidgets('las acciones responden al toque sin fallar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(VideoButtons(likesRepository: MemoryLikes(), video: _post())),
      );
      await _tick(tester);

      await tester.tap(find.byIcon(Icons.mode_comment_outlined));
      await tester.tap(find.byIcon(Icons.ios_share));
      await tester.tap(find.byIcon(Icons.bookmark_border));
      await _tick(tester);

      expect(tester.takeException(), isNull);
    });
  });
}
