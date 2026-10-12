enum VideoPlatform { local, facebook, tiktok, instagram }

enum VideoPlaybackType { asset, network, embed }

/// Entidad de dominio normalizada para videos provenientes de distintas APIs.
class VideoPost {
  final String id;
  final String caption;
  final String userName;
  final String songName;
  final String videoUrl;
  final String? externalUrl;
  final String? thumbnailUrl;
  final int likes;
  final int views;
  final VideoPlatform platform;
  final VideoPlaybackType playbackType;

  const VideoPost({
    required this.caption,
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

  String get platformLabel => switch (platform) {
        VideoPlatform.facebook => 'Facebook',
        VideoPlatform.tiktok => 'TikTok',
        VideoPlatform.instagram => 'Instagram',
        VideoPlatform.local => 'Local',
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPost &&
          id == other.id &&
          platform == other.platform &&
          videoUrl == other.videoUrl;

  @override
  int get hashCode => Object.hash(id, platform, videoUrl);
}
