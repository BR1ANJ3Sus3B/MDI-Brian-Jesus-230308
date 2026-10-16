import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:practica04_brian/infrastructure/datasources/public_video_api.dart';

void main() {
  test(
    'las tres APIs entregan videos descargables',
    () async {
      final client = http.Client();
      addTearDown(client.close);
      final api = PublicVideoApi(client);
      for (final fetch in [api.nasa, api.archive, api.wikimedia]) {
        final videos = await fetch(0);
        expect(videos, isNotEmpty);
        final video = videos.first;
        final request = http.Request('GET', Uri.parse(video.videoUrl));
        request.headers['Range'] = 'bytes=0-1023';
        final response = await client
            .send(request)
            .timeout(const Duration(seconds: 30));
        expect(
          response.statusCode,
          anyOf(200, 206),
          reason: video.platformLabel,
        );
        expect(
          response.headers['content-type'],
          contains('video'),
          reason: video.videoUrl,
        );
        await response.stream.first;
        // ignore: avoid_print
        print(
          '${video.platformLabel}: ${videos.length} videos; descarga verificada',
        );
      }
    },
    skip: !const bool.fromEnvironment('LIVE_VIDEO_APIS'),
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
