import 'package:cinemapedia/Presentation/screens/screens.dart';
import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The initial route displays the home screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Hello World'), findsOneWidget);
    expect(appRouter.namedLocation(HomeScreen.name), '/');
    expect(tester.takeException(), isNull);
  });
}
