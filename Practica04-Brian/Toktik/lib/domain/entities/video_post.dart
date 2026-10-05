/// Entidad de dominio: un video publicado en el feed.
///
/// Pertenece a la capa `domain`, por lo que no depende de ningun modelo
/// concreto de datos ni de Flutter.
class VideoPost {
  final String caption;
  final String videoUrl;
  final int likes;
  final int views;

  const VideoPost({
    required this.caption,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPost &&
          runtimeType == other.runtimeType &&
          caption == other.caption &&
          videoUrl == other.videoUrl &&
          likes == other.likes &&
          views == other.views;

  @override
  int get hashCode => Object.hash(caption, videoUrl, likes, views);

  @override
  String toString() =>
      'VideoPost(caption: $caption, videoUrl: $videoUrl, likes: $likes, views: $views)';
}