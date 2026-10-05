import 'package:flutter_test/flutter_test.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/infrastructure/models/local_video_model.dart';

void main() {
  group('LocalVideoModel.toVideoPostEntity', () {
    test('mapea name -> caption', () {
      final VideoPost post = const LocalVideoModel(
        name: 'Un video',
        videoUrl: 'assets/videos/1.mp4',
        likes: 10,
        views: 20,
      ).toVideoPostEntity();

      expect(post.caption, 'Un video');
      expect(post.videoUrl, 'assets/videos/1.mp4');
      expect(post.likes, 10);
      expect(post.views, 20);
    });
  });

  group('LocalVideoModel.fromJson', () {
    test('lee likes y views que vienen como int', () {
      final LocalVideoModel model = LocalVideoModel.fromJson(const {
        'name': 'Video',
        'videoUrl': 'assets/videos/2.mp4',
        'likes': 24230,
        'views': 1343,
      });

      expect(model.likes, 24230);
      expect(model.views, 1343);
    });

    test('acepta likes y views que vienen como double', () {
      final LocalVideoModel model = LocalVideoModel.fromJson(const {
        'name': 'Video',
        'videoUrl': 'assets/videos/2.mp4',
        'likes': 10.0,
        'views': 20.0,
      });

      expect(model.likes, 10);
      expect(model.views, 20);
    });

    test('aplica valores por defecto ante un json vacio', () {
      final VideoPost post =
          LocalVideoModel.fromJson(const <String, dynamic>{}).toVideoPostEntity();

      expect(post.caption, 'Sin titulo');
      expect(post.videoUrl, isEmpty);
      expect(post.likes, 0);
      expect(post.views, 0);
    });
  });
}