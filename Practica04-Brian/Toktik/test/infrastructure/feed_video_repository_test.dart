import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/domain/repositories/video_repository.dart';
import 'package:practica04_brian/infrastructure/datasources/public_video_api.dart';
import 'package:practica04_brian/infrastructure/repositories/feed_video_repository.dart';

class Local extends VideoRepository {
  @override
  Future<List<VideoPost>> getVideosByPage(int page) async => page < 3
      ? [VideoPost(caption: 'Local', videoUrl: 'assets/videos/$page.mp4')]
      : [];
}

class Remote extends PublicVideoApi {
  Remote() : super(http.Client());
  @override
  Future<List<VideoPost>> nasa(int page) async => throw Exception('Sin red');
  @override
  Future<List<VideoPost>> archive(int page) async => [
    const VideoPost(
      caption: 'Remoto',
      videoUrl: 'https://example.org/video.mp4',
      playbackType: VideoPlaybackType.network,
      platform: VideoPlatform.archive,
    ),
  ];
  @override
  Future<List<VideoPost>> wikimedia(int page) async => [];
}

class EmptyLocal extends VideoRepository {
  @override
  Future<List<VideoPost>> getVideosByPage(int page) async => [];
}

class PaginatedRemote extends Remote {
  @override
  Future<List<VideoPost>> archive(int page) async => [
    VideoPost(
      caption: 'Remote $page',
      videoUrl: 'https://example.org/$page.mp4',
    ),
  ];
}

void main() {
  test('sin archivos locales sigue paginando las APIs', () async {
    final api = PaginatedRemote();
    addTearDown(api.client.close);
    final repo = FeedVideoRepository(local: EmptyLocal(), api: api);
    for (var page = 0; page < 3; page++) {
      expect(
        (await repo.getVideosByPage(page)).single.videoUrl,
        'https://example.org/$page.mp4',
      );
    }
  });
  test(
    'primero locales, luego mezcla, deduplica y tolera una API caída',
    () async {
      final api = Remote();
      addTearDown(api.client.close);
      final repo = FeedVideoRepository(local: Local(), api: api);
      expect(
        (await repo.getVideosByPage(0)).single.platform,
        VideoPlatform.local,
      );
      final mixed = await repo.getVideosByPage(1);
      expect(mixed.map((v) => v.platform), [
        VideoPlatform.local,
        VideoPlatform.archive,
      ]);
      expect(
        (await repo.getVideosByPage(2)).single.platform,
        VideoPlatform.local,
      );
    },
  );
}
