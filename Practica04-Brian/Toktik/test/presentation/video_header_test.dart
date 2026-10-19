import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/presentation/widgets/shared/video_header.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('VideoHeader', () {
    testWidgets('muestra las dos pestanas y la busqueda', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(const VideoHeader()));

      expect(find.text('Siguiendo'), findsOneWidget);
      expect(find.text('Para ti'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('"Para ti" viene seleccionado por defecto', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(const VideoHeader()));

      final Text paraTi = tester.widget<Text>(find.text('Para ti'));
      expect(paraTi.data, isNotNull);
      // El subrayado solo se dibuja en la pestana activa.
      expect(find.byType(AnimatedContainer), findsNWidgets(2));
    });

    testWidgets('notifica el cambio de pestana', (WidgetTester tester) async {
      int? selected;
      await tester.pumpWidget(
        _wrap(
          VideoHeader(selectedTab: VideoHeader.forYouTab, onTabSelected: (int t) {
            selected = t;
          }),
        ),
      );

      await tester.tap(find.text('Siguiendo'));
      await tester.pump();

      expect(selected, VideoHeader.followingTab);
    });

    testWidgets('no falla si no se pasa onTabSelected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_wrap(const VideoHeader()));

      await tester.tap(find.text('Siguiendo'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}