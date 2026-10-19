import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/screens/discover/discover_screen.dart';
import 'package:practica04_brian/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

/// Repositorio que responde de inmediato, sin timers ni assets de video.
class _EmptyVideoRepository implements VideoRepository {
  @override
  Future<List<VideoPost>> getVideosByPage(int page) async =>
      const <VideoPost>[];
}

Widget _buildApp() => ChangeNotifierProvider<DiscoverProvider>(
  create: (_) => DiscoverProvider(_EmptyVideoRepository()),
  child: const MaterialApp(home: SplashScreen()),
);

void main() {
  group('SplashScreen', () {
    testWidgets('muestra la marca y el mensaje de carga', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildApp());

      expect(find.text('TokTik'), findsOneWidget);
      expect(find.text('Cargando aplicación...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Avanza el temporizador para no dejar timers pendientes.
      await tester.pump(SplashScreen.duration);
      await tester.pumpAndSettle();
    });

    testWidgets('entra al feed despues del tiempo de carga', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_buildApp());
      await tester.pump(SplashScreen.duration);
      await tester.pumpAndSettle();

      expect(find.byType(DiscoverScreen), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });
  });
}
