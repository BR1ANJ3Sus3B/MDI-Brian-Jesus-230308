import 'dart:async';
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
  // Asset I/O must not delay Flutter's first frame. Movie repositories wait
  // for this future before accessing the API key.
  final environmentReady = dotenv.load(fileName: '.env');
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
    await widget.environmentReady;
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
