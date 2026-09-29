import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/her_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/my_message_bubble.dart';
import 'package:practica03_brianjesus_230308/main.dart';

void main() {
  testWidgets('Chat screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Hola Jarvis'), findsOneWidget);
  });

  testWidgets('Sends a message and receives a reply', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), 'Hola Jarvis');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.byType(MyMessageBubble), findsWidgets);
    expect(find.text('Hola Jarvis'), findsNWidgets(2));

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.byType(HerMessageBubble), findsNWidgets(3));
  });
}