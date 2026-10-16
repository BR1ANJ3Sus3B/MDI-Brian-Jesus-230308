import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_theme.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/repositories/feed_video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/providers/theme_provider.dart';
import 'package:practica04_brian/presentation/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.whenReady;
  runApp(TokTikApp(themeProvider: themeProvider));
}

final VideoRepository _videoRepository = FeedVideoRepository();

class TokTikApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const TokTikApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<DiscoverProvider>(
          create: (_) => DiscoverProvider(_videoRepository),
        ),
        Provider<VideoRepository>.value(value: _videoRepository),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) => MaterialApp(
        title: 'TokTik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(theme.preset),
        home: const SplashScreen(),
        ),
      ),
    );
  }
}
