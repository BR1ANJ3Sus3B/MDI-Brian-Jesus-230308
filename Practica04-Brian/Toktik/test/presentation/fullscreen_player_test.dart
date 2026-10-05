import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/presentation/widgets/video/fullscreen_player.dart';

/// En pruebas no hay platform channel de `video_player`, por lo que el asset no
/// se puede inicializar. Eso permite verificar el estado de error, que es justo
/// lo que veria el usuario si le faltara un video.
Widget _wrap({
  required String videoUrl,
  String caption = 'Un video',
  String userName = 'brain.dev',
  String songName = 'sonido original',
}) => MaterialApp(
  home: Scaffold(
    body: FullScreenPlayer(
      videoUrl: videoUrl,
      caption: caption,
      userName: userName,
      songName: songName,
    ),
  ),
);

void main() {
  group('FullScreenPlayer', () {
    testWidgets('muestra el spinner mientras inicializa', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videoUrl: 'assets/videos/1.mp4'));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('si el asset no carga, avisa en vez de dejar la pantalla '
        'en negro', (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(videoUrl: 'assets/videos/inexistente.mp4', caption: 'Mi video'),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('No se pudo cargar el video'), findsOneWidget);
      expect(find.text('Mi video'), findsOneWidget);
      expect(find.byIcon(Icons.videocam_off_outlined), findsOneWidget);
    });

    testWidgets('no lanza excepciones al inicializar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(videoUrl: 'assets/videos/1.mp4'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(tester.takeException(), isNull);
    });
  });
}