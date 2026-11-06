import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/regional_release_info.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_regional_release_provider.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> mount(WidgetTester tester, {int count = 3}) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [
        movieRegionalReleaseProvider.overrideWith(
          (ref, id) async => const RegionalReleaseInfo(certification: 'A'),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MoviesSlideshow(
            movies: List.generate(
              count,
              (index) => Movie.fromJson({
                'id': index,
                'title': 'Película $index',
                'originalTitle': 'Original $index',
                'originalLanguage': 'es',
                'overview': 'Una sinopsis de prueba.',
                'voteAverage': 8,
                'backdropPath': 'https://example.com/$index.jpg',
              }),
            ),
          ),
        ),
      ),
    ));
    if (count > 0) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
  }

  PageController controller(WidgetTester tester) =>
      tester.widget<PageView>(find.byType(PageView)).controller!;

  Offset arrow(WidgetTester tester, bool left) => tester.getCenter(
        find
            .byIcon(
                left ? Icons.chevron_left_rounded : Icons.chevron_right_rounded)
            .hitTestable()
            .first,
      );

  void expectPage(WidgetTester tester, int index) {
    expect(controller(tester).page, closeTo(index.toDouble(), 0.001));
    final indicator = tester.widget<AnimatedContainer>(
      find.byKey(ValueKey('featured-indicator-$index')),
    );
    expect(indicator.constraints!.maxWidth, 22);
    expect(tester.takeException(), isNull);
  }

  testWidgets('Single taps, bounds, swipe and indicators', (tester) async {
    await mount(tester);
    await tester.tapAt(arrow(tester, true));
    await tester.pump(kDoubleTapTimeout);
    await tester.pumpAndSettle();
    expectPage(tester, 0);
    for (final index in [1, 2, 2]) {
      await tester.tapAt(arrow(tester, false));
      await tester.pump(kDoubleTapTimeout);
      await tester.pumpAndSettle();
      expectPage(tester, index);
    }
    await tester.tapAt(arrow(tester, true));
    await tester.pump(kDoubleTapTimeout);
    await tester.pumpAndSettle();
    expectPage(tester, 1);
    await tester.drag(find.byType(PageView), const Offset(650, 0));
    await tester.pumpAndSettle();
    expectPage(tester, 0);
    await tester.drag(find.byType(PageView), const Offset(-650, 0),
        kind: PointerDeviceKind.mouse);
    await tester.pumpAndSettle();
    expectPage(tester, 1);
  });

  testWidgets('Double tap cancels single navigation on either side',
      (tester) async {
    await mount(tester);
    for (final left in [false, true]) {
      controller(tester).jumpToPage(1);
      await tester.pumpAndSettle();
      final point = arrow(tester, left);
      await tester.tapAt(point);
      await tester.pump(const Duration(milliseconds: 80));
      expectPage(tester, 1);
      await tester.tapAt(point);
      await tester.pumpAndSettle();
      expectPage(tester, 0);
    }
  });

  testWidgets('Favorites retain their own gesture and empty list is safe',
      (tester) async {
    await mount(tester);
    final favorite = find.byTooltip('Agregar a favoritos').hitTestable().first;
    final container = ProviderScope.containerOf(tester.element(favorite));
    await tester.tap(favorite);
    await tester.pumpAndSettle();
    expect(container.read(favoriteMoviesProvider).single.id, 0);
    expectPage(tester, 0);
    await mount(tester, count: 0);
    expect(find.byType(PageView), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Shrinking the list clamps the current position', (tester) async {
    await mount(tester);
    controller(tester).jumpToPage(2);
    await tester.pumpAndSettle();
    await mount(tester, count: 1);
    expectPage(tester, 0);
    await tester.tapAt(arrow(tester, false));
    await tester.pump(kDoubleTapTimeout);
    await tester.pumpAndSettle();
    expectPage(tester, 0);
  });
}
