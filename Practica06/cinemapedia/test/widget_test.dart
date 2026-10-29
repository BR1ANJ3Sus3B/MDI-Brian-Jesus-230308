import 'package:cinemapedia/config/router/app_router.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';
import 'package:cinemapedia/main.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('The initial route displays the home screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [movieRepositoryProvider.overrideWithValue(_FakeRepository())],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(appRouter.namedLocation(HomeScreen.name), '/');
    expect(tester.takeException(), isNull);
  });
}

class _FakeRepository extends MoviesRepository {
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async => [];
}
