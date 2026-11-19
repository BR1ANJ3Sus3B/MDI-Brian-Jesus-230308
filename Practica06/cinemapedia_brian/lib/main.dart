import 'dart:async';
import 'dart:developer' as developer;
import 'dart:ui';
import 'package:cinemapedia/config/helpers/startup_metrics.dart';
import 'package:cinemapedia/config/locale/cinema_region.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:cinemapedia/presentation/widgets/shared/region_transition.dart';
import 'package:cinemapedia/presentation/screens/splash/cinematic_splash_screen.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';

import 'package:cinemapedia/config/router/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  StartupMetrics.start();
  WidgetsFlutterBinding.ensureInitialized();
  // Keep the original exception and stack trace visible to the debugger.  Do
  // not wrap or convert the trace: Flutter expects a VM/web StackTrace here.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    developer.log(
      details.exceptionAsString(),
      name: 'cinemapedia.flutter',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    developer.log(
      'Unhandled asynchronous error',
      name: 'cinemapedia.async',
      error: error,
      stackTrace: stackTrace,
    );
    // Returning false preserves Flutter's normal error reporting.
    return false;
  };
  final environmentReady = dotenv.load(fileName: '.env');
  // Providers can be read while the first frame is being built, so dotenv
  // must be ready before any repository accesses Environment.theMovieDbKey.
  await environmentReady;
  runApp(ProviderScope(child: MainApp(environmentReady: environmentReady)));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    StartupMetrics.mark('flutter_first_frame');
  });
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({required this.environmentReady, super.key});
  final Future<void> environmentReady;

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  bool _regionReady = false;
  String? _lastRefreshedRegionCode;
  int _catalogGeneration = 0;

  @override
  void initState() {
    super.initState();
    _waitForSavedRegion();
  }

  Future<void> _waitForSavedRegion() async {
    await ref.read(regionPreferencesReadyProvider.future);
    if (!mounted) return;
    _lastRefreshedRegionCode = ref.read(selectedRegionProvider).code;
    _regionReady = true;
    unawaited(_reloadRegionalCatalog());
  }

  Future<void> _reloadRegionalCatalog() async {
    final generation = ++_catalogGeneration;
    try {
      await widget.environmentReady;
    } catch (error, stackTrace) {
      developer.log(
        'Unable to load the application environment',
        name: 'cinemapedia.startup',
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }
    if (!mounted || generation != _catalogGeneration) return;

    ref.invalidate(nowPlayingMoviesProvider);
    ref.invalidate(popularMoviesProvider);
    ref.invalidate(upcomingMoviesProvider);
    ref.invalidate(topRatedMoviesProvider);
    ref.invalidate(movieSectionErrorsProvider);

    await Future.wait([
      ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
      ref.read(popularMoviesProvider.notifier).loadNextPage(),
      ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
      ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedRegionProvider, (previous, next) {
      if (!_regionReady || next.code == _lastRefreshedRegionCode) return;
      _lastRefreshedRegionCode = next.code;
      unawaited(_reloadRegionalCatalog());
    });

    final region = ref.watch(selectedRegionProvider);
    return MaterialApp.router(
      locale: region.locale,
      supportedLocales: CinemaRegion.all.map((region) => region.locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => CinematicSplashScreen(
        child: RegionTransition(
          child: child ?? const SizedBox.shrink(),
        ),
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
