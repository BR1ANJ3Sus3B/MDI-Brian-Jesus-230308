import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_theme.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/datasources/local_video_data_source.dart';
import 'package:practica04_brian/infrastructure/repositories/local_video_repository.dart';
import 'package:practica04_brian/presentation/providers/discover_provider.dart';
import 'package:practica04_brian/presentation/screens/discover/discover_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const TokTikApp());

/// Composición de dependencias: aqui se decide que fuente de datos se usa.
const VideoRepository _videoRepository = LocalVideoRepository(
  LocalVideoDataSource(),
);

class TokTikApp extends StatelessWidget {
  const TokTikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DiscoverProvider>(
          create: (_) => DiscoverProvider(_videoRepository),
        ),
        Provider<VideoRepository>.value(value: _videoRepository),
      ],
      child: MaterialApp(
        title: 'TokTik',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getTheme(),
        home: const DiscoverScreen(),
      ),
    );
  }
}