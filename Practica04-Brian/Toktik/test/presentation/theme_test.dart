import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/config/theme/app_theme.dart';
import 'package:practica04_brian/config/theme/theme_preset.dart';

void main() {
  test('cada modo tiene identidad visual propia', () {
    final themes = ThemePreset.values.map(AppTheme.getTheme).toList();
    expect(themes.map((theme) => theme.colorScheme.primary).toSet(),
        hasLength(4));
    expect(themes.map((theme) => theme.colorScheme.secondary).toSet(),
        hasLength(4));
  });

  test('cada modo tiene una pista temática configurada', () {
    expect(ThemePreset.values.map((preset) => preset.musicUrl).toSet(),
        hasLength(4));
    expect(ThemePreset.values.map((preset) => preset.musicTitle), containsAll(
        <String>['Melodía navideña', 'Melodía de Día de Muertos',
          'Melodía de Día de Reyes']));
  });

  testWidgets('el selector muestra los cuatro modos', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.getTheme(ThemePreset.navidad),
      home: Scaffold(
        body: PopupMenuButton<ThemePreset>(
          tooltip: 'Cambiar modo visual',
          itemBuilder: (_) => ThemePreset.values.map((preset) =>
              PopupMenuItem(value: preset, child: Text(preset.label))).toList(),
        ),
      ),
    ));
    await tester.tap(find.byTooltip('Cambiar modo visual'));
    await tester.pumpAndSettle();
    expect(find.text('Navidad'), findsOneWidget);
    expect(find.text('Día de Muertos'), findsOneWidget);
    expect(find.text('Día de Reyes'), findsOneWidget);
  });
}
