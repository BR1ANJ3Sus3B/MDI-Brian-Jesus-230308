import 'package:flutter/services.dart';
import 'package:practica04_brian/domain/repositories/video_data_source.dart';
import 'package:practica04_brian/shared/data/local_video_posts.dart';

/// Lee el manifiesto real: incluye también archivos nuevos y omite los ausentes.
class LocalVideoDataSource implements VideoDataSource {
  const LocalVideoDataSource();

  @override
  Future<List<Map<String, dynamic>>> getVideosByPage(int page) async {
    if (page < 0) return const [];
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final paths =
        manifest
            .listAssets()
            .where(
              (path) =>
                  path.startsWith('assets/videos/') &&
                  path.toLowerCase().endsWith('.mp4'),
            )
            .toList()
          ..sort();
    final known = {for (final post in videoPosts) post['videoUrl']: post};
    final ordered = [
      ...videoPosts
          .map((post) => post['videoUrl'] as String)
          .where(paths.contains),
      ...paths.where((path) => !known.containsKey(path)),
    ];
    final start = page * 4;
    if (start >= ordered.length) return const [];
    return ordered
        .skip(start)
        .take(4)
        .map(
          (path) =>
              known[path] ??
              {
                'name': path
                    .split('/')
                    .last
                    .replaceFirst(RegExp(r'\.mp4$', caseSensitive: false), ''),
                'videoUrl': path,
                'userName': 'local',
              },
        )
        .toList();
  }
}
