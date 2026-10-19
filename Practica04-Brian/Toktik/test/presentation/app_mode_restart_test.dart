import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/config/theme/theme_preset.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/main.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/providers/theme_provider.dart';
import 'package:practica04_brian/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

// Aísla la navegación de audio y almacenamiento nativos.
class _ThemeState extends ChangeNotifier implements ThemeProvider {
  ThemePreset _preset = ThemePreset.toktik;

  @override
  ThemePreset get preset => _preset;

  @override
  Future<void> setPreset(ThemePreset value) async {
    if (_preset == value) return;
    _preset = value;
    notifyListeners();
  }

  void notifyMusicChange() => notifyListeners();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('cambiar de modo reinicia navegación y estado del feed', (
    tester,
  ) async {
    final theme = _ThemeState();
    await tester.pumpWidget(TokTikApp(themeProvider: theme));
    final context = tester.element(find.byType(SplashScreen));
    final previousFeed = context.read<DiscoverProvider>();
    final previousRepository = context.read<VideoRepository>();
    final previousNavigator = Navigator.of(context);
    previousNavigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Sesión anterior')),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Sesión anterior'), findsOneWidget);

    await theme.setPreset(ThemePreset.navidad);
    await tester.pump();
    final restartedContext = tester.element(find.byType(SplashScreen));
    expect(find.text('Sesión anterior'), findsNothing);
    expect(Navigator.of(restartedContext), isNot(same(previousNavigator)));
    expect(Navigator.of(restartedContext).canPop(), isFalse);
    expect(
      restartedContext.read<DiscoverProvider>(),
      isNot(same(previousFeed)),
    );
    expect(
      restartedContext.read<VideoRepository>(),
      isNot(same(previousRepository)),
    );
    expect(restartedContext.read<DiscoverProvider>().videos, isEmpty);
    expect(restartedContext.read<ThemeProvider>(), same(theme));
    expect(
      Theme.of(restartedContext).colorScheme.primary,
      ThemePreset.navidad.primary,
    );
    // Una petición tardía de la sesión descartada ya no debe cargar datos.
    await previousFeed.loadNextPage();
    expect(previousFeed.videos, isEmpty);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    theme.dispose();
  });

  testWidgets('el mismo modo y cambios de música conservan la sesión', (
    tester,
  ) async {
    final theme = _ThemeState();
    await tester.pumpWidget(TokTikApp(themeProvider: theme));
    final context = tester.element(find.byType(SplashScreen));
    final navigator = Navigator.of(context);
    final feed = context.read<DiscoverProvider>();

    await theme.setPreset(ThemePreset.toktik);
    theme.notifyMusicChange();
    await tester.pump();
    final currentContext = tester.element(find.byType(SplashScreen));
    expect(Navigator.of(currentContext), same(navigator));
    expect(currentContext.read<DiscoverProvider>(), same(feed));

    await tester.pumpWidget(const SizedBox.shrink());
    theme.dispose();
  });
}
