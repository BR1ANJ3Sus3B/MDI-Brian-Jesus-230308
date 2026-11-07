import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/entities/regional_release_info.dart';
import 'package:cinemapedia/domain/repositories/movies_repository.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/providers/favorites/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_info_provider.dart';
import 'package:cinemapedia/presentation/screens/settings/settings_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/categories_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/home_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_screen.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_collection_screen.dart';
import 'package:cinemapedia/presentation/screens/favorites/favorites_screen.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/region_transition.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_drawer.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Every ARB has all messages and all seven locales resolve', () async {
    final template =
        jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map;
    final keys =
        template.keys.where((key) => !key.toString().startsWith('@')).toSet();
    for (final region in CinemaRegion.all) {
      final messages = jsonDecode(
          File('lib/l10n/app_${region.locale.languageCode}.arb')
              .readAsStringSync()) as Map;
      expect(
          messages.keys.where((key) => !key.toString().startsWith('@')).toSet(),
          keys);
      expect(
          messages.values
              .whereType<String>()
              .every((value) => value.isNotEmpty),
          isTrue);
      final l10n = await AppLocalizations.delegate.load(region.locale);
      expect(l10n.localeName, region.locale.languageCode);
      expect(
          HumanFormats.certification(null, region.code,
              unavailable: l10n.noCertification),
          l10n.noCertification);
    }
    final german = await AppLocalizations.delegate.load(const Locale('de'));
    expect(HumanFormats.rating(8.5, german.localeName), '8,5');
    expect(
        HumanFormats.certification('16', 'DE',
            unavailable: german.noCertification),
        'FSK 16');
    final russian = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(russian.savedTitles(1), '1 сохранённый фильм');
    expect(russian.savedTitles(2), '2 сохранённых фильма');
    expect(russian.savedTitles(5), '5 сохранённых фильмов');
  });

  testWidgets('All settings options, transition, persistence and favorites',
      (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    await container.read(regionPreferencesReadyProvider.future);
    expect(container.read(selectedRegionProvider).code, 'MX');
    await container
        .read(favoriteMoviesProvider.notifier)
        .toggle(_movie(1, 'MX'));
    await _mount(tester, container, const SettingsScreen());
    for (final label in [
      'Estados Unidos (English)',
      'México (Español)',
      'Deutschland (Deutsch)',
      '日本 (日本語)',
      '中国 (简体中文)',
      'Россия (Русский)',
      'Brasil (Português)'
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    await tester.tap(find.text('日本 (日本語)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(container.read(selectedRegionProvider).code, 'JP');
    expect(find.byKey(const ValueKey('region-transition-JP')), findsOneWidget);
    expect(find.text('日本向けにCinemapediaを設定しています…'), findsOneWidget);
    expect(container.read(regionTransitionProvider), isTrue);
    await tester.pump(const Duration(milliseconds: 650));
    await tester.pumpAndSettle();
    expect(container.read(regionTransitionProvider), isFalse);
    expect(find.text('設定'), findsOneWidget);
    expect(container.read(favoriteMoviesProvider).single.id, 1);
    final restarted = SelectedRegionNotifier();
    await restarted.ready;
    expect(restarted.current.locale, const Locale('ja', 'JP'));
    restarted.dispose();
    expect(tester.takeException(), isNull);
  });

  for (final region in CinemaRegion.all) {
    testWidgets(
        '${region.code}: menus, secondary screens, search and narrow layout',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final container = _container();
      addTearDown(container.dispose);
      await container.read(selectedRegionProvider.notifier).select(region);
      final l10n = await AppLocalizations.delegate.load(region.locale);

      await _mount(tester, container, const CategoriesScreen());
      expect(find.text(l10n.exploreCategories), findsOneWidget);
      expect(find.text(l10n.categories), findsOneWidget);
      // The same drawer still opens and closes with horizontal gestures.
      await tester.dragFrom(const Offset(1, 400), const Offset(280, 0));
      await tester.pumpAndSettle();
      expect(find.text(l10n.settings), findsOneWidget);
      expect(find.byType(CinemapediaDrawer), findsOneWidget);
      await tester.dragFrom(const Offset(250, 400), const Offset(-280, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await _mount(tester, container, const FavoritesScreen());
      expect(find.text(l10n.emptyFavorites), findsOneWidget);
      expect(find.text(l10n.exploreMovies), findsOneWidget);
      expect(tester.takeException(), isNull);

      await _mount(tester, container, const SettingsScreen());
      expect(find.text(l10n.countryLanguage), findsOneWidget);
      expect(find.text(l10n.settings), findsOneWidget);
      expect(tester.takeException(), isNull);

      await container.read(nowPlayingMoviesProvider.notifier).loadNextPage();
      await _mount(
          tester, container, const MovieCollectionScreen(type: 'now-playing'));
      expect(find.text(l10n.inTheaters), findsOneWidget);
      expect(tester.takeException(), isNull);

      await container.read(movieInfoProvider.notifier).loadMovie('1');
      await _mount(tester, container, const MovieScreen(movieId: '1'));
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
      await tester.pumpAndSettle();
      expect(find.text(l10n.synopsis), findsOneWidget);
      expect(tester.takeException(), isNull);

      await _mount(tester, container, const HomeScreen());
      expect(find.text(l10n.stories), findsOneWidget);
      expect(find.text(l10n.viewDetails), findsWidgets);
      expect(find.text('Title ${region.code} 1'), findsWidgets);
      final page = tester.widget<PageView>(find.byType(PageView)).controller!;
      await tester.drag(find.byType(PageView), const Offset(-350, 0));
      await tester.pumpAndSettle();
      expect(page.page, closeTo(1, 0.001));
      await tester
          .tap(find.byIcon(Icons.chevron_left_rounded).hitTestable().first);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(page.page, closeTo(0, 0.001));
      expect(tester.takeException(), isNull);

      await _mount(
          tester,
          container,
          Builder(
              builder: (context) => Scaffold(
                    body: TextButton(
                        onPressed: () => showSearch<Movie?>(
                              context: context,
                              delegate: SearchMovieDelegate(
                                  searchLabel: context.l10n.searchMovies,
                                  initialMovies: [],
                                  searchMovies: (_) async => []),
                            ),
                        child: const Text('search-test')),
                  )));
      await tester.tap(find.text('search-test'));
      await tester.pumpAndSettle();
      expect(find.text(l10n.searchHint), findsOneWidget);
      expect(find.text(l10n.searchMovies), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pumpAndSettle();
      expect(find.text(l10n.noResults('xyz')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip(l10n.back));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('Reduced motion completes without the 700ms transition',
      (tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final container = _container();
    addTearDown(container.dispose);
    await container.read(regionPreferencesReadyProvider.future);
    await _mount(tester, container, const SettingsScreen(), reduced: true);
    await tester.tap(find.text('Deutschland (Deutsch)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(container.read(regionTransitionProvider), isFalse);
    expect(container.read(selectedRegionProvider).code, 'DE');
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Changing region resets the carousel and replaces movie data',
      (tester) async {
    final container = _container();
    addTearDown(container.dispose);
    await container.read(regionPreferencesReadyProvider.future);
    await container.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    await _mount(tester, container, const HomeScreen());
    tester.widget<PageView>(find.byType(PageView)).controller!.jumpToPage(1);
    await tester.pumpAndSettle();
    await container
        .read(selectedRegionProvider.notifier)
        .select(CinemaRegion.fromCode('DE'));
    await container.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    await tester.pumpAndSettle();
    expect(tester.widget<PageView>(find.byType(PageView)).controller!.page, 0);
    expect(find.text('Title DE 1'), findsWidgets);
    expect(find.text('Title MX 1'), findsNothing);
    expect(find.byType(MoviesSlideshow), findsOneWidget);
  });

  test('Late requests from a previous country cannot overwrite the new catalog',
      () async {
    final delayed = Completer<List<Movie>>();
    final container = _container(
        repository: (region) => region == 'MX'
            ? _DelayedRepository(region, delayed.future)
            : _Repository(region));
    addTearDown(container.dispose);
    await container.read(regionPreferencesReadyProvider.future);
    container.listen(nowPlayingMoviesProvider, (_, next) {});
    final oldRequest =
        container.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    await container
        .read(selectedRegionProvider.notifier)
        .select(CinemaRegion.fromCode('JP'));
    await container.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    delayed.complete([_movie(99, 'MX')]);
    await oldRequest;
    expect(container.read(nowPlayingMoviesProvider).map((movie) => movie.title),
        ['Title JP 1', 'Title JP 2']);
    expect(container.read(movieSectionErrorsProvider), isEmpty);
  });

  testWidgets('Connection errors are translated and retry preserves the region',
      (tester) async {
    final repository = _RetryRepository('DE');
    final container = _container(repository: (_) => repository);
    addTearDown(container.dispose);
    await container
        .read(selectedRegionProvider.notifier)
        .select(CinemaRegion.fromCode('DE'));
    await _mount(
        tester, container, const MovieCollectionScreen(type: 'now-playing'));
    final l10n = await AppLocalizations.delegate.load(const Locale('de'));
    expect(find.text(l10n.collectionError), findsOneWidget);
    expect(find.textContaining('internal'), findsNothing);
    await tester.tap(find.text(l10n.retry));
    await tester.pumpAndSettle();
    expect(find.text('Title DE 1'), findsOneWidget);
    expect(container.read(selectedRegionProvider).code, 'DE');
    expect(tester.takeException(), isNull);
  });
}

ProviderContainer _container({MoviesRepository Function(String)? repository}) =>
    ProviderContainer(overrides: [
      movieRepositoryProvider.overrideWith((ref) {
        final code = ref.watch(selectedRegionProvider).code;
        return repository?.call(code) ?? _Repository(code);
      }),
      actorsByMovieProvider.overrideWith(
          (ref) => ActorsByMovieNotifier(getActors: (_) async => [])),
    ]);

Future<void> _mount(
    WidgetTester tester, ProviderContainer container, Widget screen,
    {bool reduced = false}) async {
  await tester.pumpWidget(UncontrolledProviderScope(
    container: container,
    child: Consumer(
        builder: (context, ref, _) => MaterialApp(
              theme: AppTheme().getTheme(),
              locale: ref.watch(selectedRegionProvider).locale,
              supportedLocales: CinemaRegion.all.map((region) => region.locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: (context, child) => MediaQuery(
                data:
                    MediaQuery.of(context).copyWith(disableAnimations: reduced),
                child: RegionTransition(child: child!),
              ),
              home: screen,
            )),
  ));
  await tester.pumpAndSettle();
}

Movie _movie(int id, String region) => Movie.fromJson({
      'id': id,
      'title': 'Title $region $id',
      'originalTitle': 'Original $id',
      'originalLanguage': 'en',
      'overview': 'A long overview for the selected movie.',
      'releaseDate': '2026-11-06',
      'voteAverage': 8.5,
      'backdropPath': 'https://example.com/backdrop.jpg',
      'posterPath': 'https://example.com/poster.jpg',
      'runtimeMinutes': 123,
    });

class _Repository extends MoviesRepository {
  _Repository(this.region);
  final String region;
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async =>
      [_movie(1, region), _movie(2, region)];
  @override
  Future<List<Movie>> getPopular({int page = 1}) => getNowPlaying();
  @override
  Future<List<Movie>> getUpcoming({int page = 1}) => getNowPlaying();
  @override
  Future<List<Movie>> getTopRated({int page = 1}) => getNowPlaying();
  @override
  Future<Movie> getMovieById(String id) async => _movie(int.parse(id), region);
  @override
  Future<List<Movie>> searchMovies(String query) => getNowPlaying();
  @override
  Future<RegionalReleaseInfo> getRegionalReleaseInfo(
          int movieId, String regionCode) async =>
      RegionalReleaseInfo(releaseDate: DateTime(2026, 11, 6));
}

class _DelayedRepository extends _Repository {
  _DelayedRepository(super.region, this.response);
  final Future<List<Movie>> response;
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) => response;
}

class _RetryRepository extends _Repository {
  _RetryRepository(super.region);
  bool failed = false;
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    if (!failed) {
      failed = true;
      throw StateError('internal exception must never be displayed');
    }
    return super.getNowPlaying(page: page);
  }
}
