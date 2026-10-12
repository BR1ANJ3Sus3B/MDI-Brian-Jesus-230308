import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/widgets/video/video_background.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

/// Reproductor compatible con Flutter Web y móvil.
///
/// - asset: reproduce archivos locales.
/// - network: reproduce una URL directa de video.
/// - embed: muestra la portada y abre el reproductor oficial de la plataforma.
class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final String userName;
  final String songName;
  final String? externalUrl;
  final String? thumbnailUrl;
  final VideoPlaybackType playbackType;
  final VideoPlatform platform;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    required this.playbackType,
    required this.platform,
    this.userName = 'usuario',
    this.songName = 'sonido original',
    this.externalUrl,
    this.thumbnailUrl,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VideoPlayerController? _videoController;
  bool _initialized = false;
  Object? _error;

  bool get _usesExternalPlayer =>
      widget.playbackType == VideoPlaybackType.embed;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    if (_usesExternalPlayer) {
      if (mounted) {
        setState(() {
          _initialized = true;
          _error = null;
        });
      }
      return;
    }

    try {
      final controller = widget.playbackType == VideoPlaybackType.asset
          ? VideoPlayerController.asset(widget.videoUrl)
          : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      _videoController = controller;
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.initialize();
      await controller.play();

      if (!mounted) return;
      setState(() {
        _initialized = true;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _initialized = false;
        _error = error;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    final controller = _videoController;
    if (!_initialized || controller == null) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  Future<void> _openOfficialVideo() async {
    final rawUrl = (widget.externalUrl?.isNotEmpty ?? false)
        ? widget.externalUrl!
        : widget.videoUrl;
    final uri = Uri.tryParse(rawUrl);

    if (uri == null || !await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir el video.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _ErrorVideo(message: widget.caption, platform: widget.platform);
    }

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        if (_usesExternalPlayer)
          _ExternalVideoPreview(
            thumbnailUrl: widget.thumbnailUrl,
            platform: widget.platform,
            onOpen: _openOfficialVideo,
          )
        else
          GestureDetector(
            onTap: _togglePlayback,
            child: _DirectVideo(controller: _videoController!),
          ),
        const VideoBackground.bottom(),
        Positioned(
          left: 16,
          right: 96,
          bottom: 24,
          child: _VideoInfo(
            caption: widget.caption,
            userName: widget.userName,
            songName: widget.songName,
            platform: widget.platform,
          ),
        ),
      ],
    );
  }
}

class _ExternalVideoPreview extends StatelessWidget {
  final String? thumbnailUrl;
  final VideoPlatform platform;
  final VoidCallback onOpen;

  const _ExternalVideoPreview({
    required this.thumbnailUrl,
    required this.platform,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (platform) {
      VideoPlatform.facebook => 'Facebook',
      VideoPlatform.tiktok => 'TikTok',
      VideoPlatform.instagram => 'Instagram',
      VideoPlatform.local => 'Video',
    };

    return ColoredBox(
      color: AppColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
            Image.network(
              thumbnailUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ColoredBox(color: const Color(0x33000000)),
          Center(
            child: FilledButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.play_arrow_rounded, size: 30),
              label: Text('Ver en $label'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectVideo extends StatelessWidget {
  final VideoPlayerController controller;

  const _DirectVideo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio == 0
              ? 9 / 16
              : controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

class _VideoInfo extends StatelessWidget {
  final String caption;
  final String userName;
  final String songName;
  final VideoPlatform platform;

  const _VideoInfo({
    required this.caption,
    required this.userName,
    required this.songName,
    required this.platform,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final platformLabel = switch (platform) {
      VideoPlatform.facebook => 'Facebook',
      VideoPlatform.tiktok => 'TikTok',
      VideoPlatform.instagram => 'Instagram',
      VideoPlatform.local => 'Local',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x99000000),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(platformLabel, style: textTheme.labelSmall),
        ),
        const SizedBox(height: 8),
        Text(
          '@$userName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleLarge?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          caption,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            shadows: const [Shadow(color: Color(0x80000000), blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.music_note, size: 15, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                songName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorVideo extends StatelessWidget {
  final String message;
  final VideoPlatform platform;

  const _ErrorVideo({required this.message, required this.platform});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off_outlined,
                color: AppColors.textTertiary,
                size: 44,
              ),
              const SizedBox(height: 16),
              Text(
                'No se pudo cargar el video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                '${platform.name}: $message',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
