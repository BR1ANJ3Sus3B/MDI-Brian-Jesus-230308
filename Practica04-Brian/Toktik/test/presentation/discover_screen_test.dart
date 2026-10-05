import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/config/theme/app_theme.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/screens/discover/discover_screen.dart';
import 'package:provider/provider.dart';

/// Repositorio controlado por el test: cada llamada devuelve un [Completer]
/// que el test resuelve cuando quiere, sin timers ni assets de video.
class _ControllableVideoRepository implements VideoRepository {
  final List<Completer<List<VideoPost>>> pending =
      <Completer<List<VideoPost>>>[];

  int calls = 0;

  @override
  Future<List<VideoPost>> getVideosByPage(int page) {
    calls++;
    final Completer<List<VideoPost>> completer =
        Completer<List<VideoPost>>();
    pending.add(completer);
    return completer.future;
  }
}

Widget _buildApp(VideoRepository repository) => MaterialApp(
  home: ChangeNotifierProvider<DiscoverProvider>(
    create: (_) => DiscoverProvider(repository),
    child: const DiscoverScreen(),
  ),
);

void main() {
  testWidgets('muestra el spinner mientras la peticion no responde', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp(_ControllableVideoRepository()));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('oculta el spinner cuando la pagina llega vacia', (
    WidgetTester tester,
  ) async {
    final _ControllableVideoRepository repository =
        _ControllableVideoRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pump();

    repository.pending.first.complete(const <VideoPost>[]);
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No hay videos para mostrar.'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });

  testWidgets('muestra el mensaje de error si la fuente de datos falla', (
    WidgetTester tester,
  ) async {
    final _ControllableVideoRepository repository =
        _ControllableVideoRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pump();

    repository.pending.first.completeError(StateError('sin conexion'));
    await tester.pumpAndSettle();

    expect(find.text('No se pudieron cargar los videos.'), findsOneWidget);
  });

  testWidgets('Reintentar vuelve a pedir la primera pagina', (
    WidgetTester tester,
  ) async {
    final _ControllableVideoRepository repository =
        _ControllableVideoRepository();

    await tester.pumpWidget(_buildApp(repository));
    await tester.pump();

    repository.pending.first.completeError(StateError('sin conexion'));
    await tester.pumpAndSettle();
    expect(find.text('No se pudieron cargar los videos.'), findsOneWidget);

    await tester.tap(find.text('Reintentar'));
    await tester.pump();

    // Una segunda peticion quedo en vuelo -> vuelve a verse el spinner.
    expect(repository.calls, 2);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  test('AppTheme usa Material 3 y modo oscuro', () {
    final ThemeData theme = AppTheme.getTheme();

    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, Colors.black);
  });
}