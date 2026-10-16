import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/infrastructure/datasources/local_video_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'todos los MP4 existentes aparecen una vez y con su ruta exacta',
    () async {
      final expected = Directory('assets/videos')
          .listSync()
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.mp4'))
          .map((file) => file.path.replaceAll(r'\', '/'))
          .toSet();
      final actual = <String>[];
      const source = LocalVideoDataSource();
      for (var page = 0; page < 1000; page++) {
        final videos = await source.getVideosByPage(page);
        if (videos.isEmpty) break;
        actual.addAll(videos.map((video) => video['videoUrl'] as String));
      }
      expect(actual.toSet(), expected);
      expect(actual.length, expected.length);
      expect(await source.getVideosByPage(-1), isEmpty);
    },
  );
}
