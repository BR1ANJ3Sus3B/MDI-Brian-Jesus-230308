import 'package:practica04_brian/domain/entities/video_post.dart';

/// Convierte la respuesta normalizada de cualquier fuente a la entidad de dominio.
class LocalVideoModel {
  final String id;
  final String name;
  final String userName;
  final String songName;
  final String videoUrl;
  final String? externalUrl;
  final String? thumbnailUrl;
  final int likes;
  final int views;
  final VideoPlatform platform;
  final VideoPlaybackType playbackType;

  const LocalVideoModel({
    required this.name,
    required this.videoUrl,
    this.id = '',
    this.userName = 'usuario',
    this.songName = 'sonido original',
    this.externalUrl,
    this.thumbnailUrl,
    this.likes = 0,
    this.views = 0,
    this.platform = VideoPlatform.local,
    this.playbackType = VideoPlaybackType.asset,
  });

  factory LocalVideoModel.fromJson(Map<String, dynamic> json) {
    final String playbackValue = (json['playbackType'] as String? ?? 'asset').toLowerCase();

    return LocalVideoModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? 'Sin título',
      userName: json['userName'] as String? ?? 'usuario',
      songName: json['songName'] as String? ?? 'sonido original',
      videoUrl: json['videoUrl'] as String? ?? '',
      externalUrl: json['externalUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      platform: VideoPlatform.local,
      playbackType: switch (playbackValue) {
        'network' => VideoPlaybackType.network,
        'embed' => VideoPlaybackType.embed,
        _ => VideoPlaybackType.asset,
      },
    );
  }

  VideoPost toVideoPostEntity() => VideoPost(
        id: id,
        caption: name,
        userName: userName,
        songName: songName,
        videoUrl: videoUrl,
        externalUrl: externalUrl,
        thumbnailUrl: thumbnailUrl,
        likes: likes,
        views: views,
        platform: platform,
        playbackType: playbackType,
      );
}
