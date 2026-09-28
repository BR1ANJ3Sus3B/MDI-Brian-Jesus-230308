// Harness de documentación: renderiza la pantalla real de la aplicación y
// exporta una captura PNG por cada estado del contador en `docs/imagenes/`.
//
// No forma parte de la suite `flutter test`. Se ejecuta a demanda:
//
//   powershell -ExecutionPolicy Bypass -File tool/capturas/generar.ps1
//
// Equivalente en dos pasos:
//
//   flutter test tool/capturas/generar_capturas_test.dart --update-goldens

import 'dart:io';

import 'package:brian_mdi_230308/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dimensiones lógicas y de píxeles de un móvil de referencia (1080x2340).
const Size _tamanoFisico = Size(1080, 2340);
const double _dpr = 3.0;

/// Carpeta donde `generar.ps1` descarga los `.ttf` de Space Grotesk.
const String _fuentesDir = 'tool/capturas/.fuentes';

/// Familia que `google_fonts` pide para cada variante de Space Grotesk.
/// Ver `GoogleFontsFamilyWithVariant.toString()`: `<familia>_<variante>`.
const Map<String, String> _fuentesPorFamilia = <String, String>{
  'SpaceGrotesk_regular': 'SpaceGrotesk-Regular.ttf',
  'SpaceGrotesk_300': 'SpaceGrotesk-Light.ttf',
  'SpaceGrotesk_700': 'SpaceGrotesk-Bold.ttf',
  'Space Grotesk': 'SpaceGrotesk-Regular.ttf',
};

class _Estado {
  const _Estado(this.nombre, this.valor);

  final String nombre;
  final int valor;
}

const List<_Estado> _estados = <_Estado>[
  _Estado('low', 0),
  _Estado('medium', 14),
  _Estado('high', 24),
  _Estado('negative', -3),
];

void main() {
  setUpAll(() async {
    // Sin red: las fuentes se resuelven desde los `.ttf` descargados.
    GoogleFonts.config.allowRuntimeFetching = false;
    await _registrarFuentes();
  });

  for (final estado in _estados) {
    testWidgets('captura estado ${estado.nombre} (${estado.valor})', (
      WidgetTester tester,
    ) async {
      tester.view
        ..physicalSize = _tamanoFisico
        ..devicePixelRatio = _dpr;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await _llevarA(tester, estado.valor);

      // El número debe coincidir con el estado pedido.
      expect(find.text('${estado.valor}'), findsOneWidget);

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('../../docs/imagenes/app-estado-${estado.nombre}.png'),
      );
    });
  }
}

/// Aplica las pulsaciones necesarias para pasar de 0 al valor pedido.
Future<void> _llevarA(WidgetTester tester, int objetivo) async {
  final icono = objetivo >= 0 ? Icons.add : Icons.remove;
  for (var i = 0; i < objetivo.abs(); i++) {
    await tester.tap(find.byIcon(icono));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// Registra Space Grotesk con los nombres de familia que usa `google_fonts`,
/// para que el texto se dibuje con la tipografía real de la aplicación.
Future<void> _registrarFuentes() async {
  for (final MapEntry(key: familia, value: archivo) in _fuentesPorFamilia.entries) {
    final bytes = await File('$_fuentesDir/$archivo').readAsBytes();
    final loader = FontLoader(familia)
      ..addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
    await loader.load();
  }
}
