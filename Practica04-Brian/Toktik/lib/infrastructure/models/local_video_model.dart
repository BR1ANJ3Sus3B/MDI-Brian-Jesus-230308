import 'package:practica04_brian/domain/entities/video_post.dart';

/// Modelo de datos (capa `infrastructure`) que sabe convertirse a entidad.
///
/// Usa el patron Data Model: el JSON cruza la frontera de datos y solo se
/// transforma a [VideoPost] mediante `toVideoPostEntity()`.
class LocalVideoModel {
  final String name;
  final String videoUrl;
  final int likes;
  final int views;

  const LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) =>
      LocalVideoModel(
        name: json['name'] as String? ?? 'Sin titulo',
        videoUrl: json['videoUrl'] as String? ?? '',
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        views: (json['views'] as num?)?.toInt() ?? 0,
      );

  VideoPost toVideoPostEntity() => VideoPost(
    caption: name,
    videoUrl: videoUrl,
    likes: likes,
    views: views,
  );
}