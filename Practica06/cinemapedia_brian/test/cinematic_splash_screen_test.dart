import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/screens/splash/cinematic_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the localized introduction once before its child',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('es', 'MX'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: CinematicSplashScreen(child: Scaffold(body: Text('Home'))),
      ),
    );

    expect(find.text('CINEMAPEDIA'), findsOneWidget);
    expect(find.text('El cine comienza aquí'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses a short static frame when reduced motion is enabled',
      (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en', 'US'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: CinematicSplashScreen(child: Scaffold(body: Text('Home'))),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Cinema starts here'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
