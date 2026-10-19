import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practica04_brian/config/theme/app_theme.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/datasources/public_video_api.dart';
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

class TokTikApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const TokTikApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: Consumer<ThemeProvider>(
        // Un modo nuevo descarta la navegación y el estado de la sesión anterior.
        // El ThemeProvider permanece fuera para conservar la selección guardada.
        builder: (context, theme, child) => MultiProvider(
          key: ValueKey(theme.preset),
          providers: [
            Provider<http.Client>(
              create: (_) => http.Client(),
              dispose: (_, client) => client.close(),
            ),
            Provider<VideoRepository>(
              create: (context) => FeedVideoRepository(
                api: PublicVideoApi(context.read<http.Client>()),
              ),
            ),
            ChangeNotifierProvider<DiscoverProvider>(
              create: (context) =>
                  DiscoverProvider(context.read<VideoRepository>()),
            ),
          ],
          child: MaterialApp(
            title: 'TokTik',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(theme.preset),
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
