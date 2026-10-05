/// Entidad de dominio: un video publicado en el feed.
///
/// Pertenece a la capa `domain`, por lo que no depende de ningun modelo
/// concreto de datos ni de Flutter.
class VideoPost {
  final String caption;

  /// Autor de la publicacion, mostrado como `@usuario`.
  final String userName;

  /// Audio del video, mostrado junto al icono de nota musical.
  final String songName;

  final String videoUrl;
  final int likes;
  final int views;

  const VideoPost({
    required this.caption,
    required this.videoUrl,
    this.userName = 'usuario',
    this.songName = 'sonido original',
    this.likes = 0,
    this.views = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPost &&
          runtimeType == other.runtimeType &&
          caption == other.caption &&
          userName == other.userName &&
          songName == other.songName &&
          videoUrl == other.videoUrl &&
          likes == other.likes &&
          views == other.views;

  @override
  int get hashCode =>
      Object.hash(caption, userName, songName, videoUrl, likes, views);

  @override
  String toString() =>
      'VideoPost(caption: $caption, userName: $userName, songName: $songName, '
      'videoUrl: $videoUrl, likes: $likes, views: $views)';
}