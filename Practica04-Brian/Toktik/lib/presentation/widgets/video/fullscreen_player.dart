import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';
import 'package:practica04_brian/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl, caption, userName, songName;
  final String? externalUrl, thumbnailUrl;
  final VideoPlaybackType playbackType;
  final VideoPlatform platform;
  final bool isActive, isMuted;
  final ValueChanged<bool>? onMutedChanged;

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
    this.isActive = true,
    this.isMuted = true,
    this.onMutedChanged,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  bool _initialized = false;
  bool _muted = true;
  bool _pausedByUser = false;
  bool _foreground = true;
  Object? _error;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _muted = widget.isMuted;
    _initialize();
  }

  Future<void> _initialize() async {
    final generation = ++_generation;
    final old = _videoController;
    _videoController = null;
    if (old != null) unawaited(old.dispose());
    try {
      final controller = widget.playbackType == VideoPlaybackType.asset
          ? VideoPlayerController.asset(widget.videoUrl)
          : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _videoController = controller;
      controller.addListener(() {
        if (!mounted ||
            generation != _generation ||
            !controller.value.hasError ||
            _error != null) {
          return;
        }
        setState(() {
          _error = controller.value.errorDescription;
          _initialized = false;
        });
      });
      await controller.initialize().timeout(const Duration(seconds: 25));
      if (!mounted || generation != _generation) return;
      await controller.setLooping(true);
      if (!mounted || generation != _generation) return;
      await controller.setVolume(_muted ? 0 : 1);
      if (!mounted || generation != _generation) return;
      setState(() {
        _initialized = true;
        _error = null;
      });
      await _syncPlayback();
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _initialized = false;
        _error = error;
      });
    }
  }

  Future<void> _syncPlayback() async {
    final controller = _videoController;
    if (!_initialized || controller == null) return;
    try {
      if (widget.isActive && _foreground && !_pausedByUser) {
        await controller.play();
      } else {
        await controller.pause();
      }
      if (mounted) setState(() {});
    } catch (_) {
      // Un navegador puede exigir un toque para autorizar la reproducción.
      if (mounted) setState(() => _pausedByUser = true);
    }
  }

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _muted = widget.isMuted;
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.playbackType != widget.playbackType) {
      _initialized = false;
      _error = null;
      _pausedByUser = false;
      _initialize();
    } else {
      if (oldWidget.isMuted != widget.isMuted) _applyVolume();
      if (oldWidget.isActive != widget.isActive) _syncPlayback();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _syncPlayback();
  }

  Future<void> _applyVolume() async {
    try {
      await _videoController?.setVolume(_muted ? 0 : 1);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cambiar el volumen. Intenta de nuevo.'),
        ),
      );
    }
  }

  void _toggleSound() {
    setState(() => _muted = !_muted);
    _applyVolume();
    widget.onMutedChanged?.call(_muted);
  }

  @override
  void dispose() {
    ++_generation;
    WidgetsBinding.instance.removeObserver(this);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _ErrorVideo(message: widget.caption, platform: widget.platform),
          Positioned(
            bottom: 140,
            left: 24,
            child: FilledButton.icon(
              onPressed: () {
                setState(() {
                  _error = null;
                  _initialized = false;
                });
                _initialize();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ),
        ],
      );
    }
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: () {
            _pausedByUser = !_pausedByUser;
            _syncPlayback();
          },
          child: _DirectVideo(controller: _videoController!),
        ),
        if (_pausedByUser)
          const IgnorePointer(
            child: Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 72,
                color: Colors.white,
              ),
            ),
          ),
        const VideoBackground.bottom(),
        Positioned(
          left: 16,
          top: 130,
          child: IconButton.filledTonal(
            tooltip: _muted ? 'Activar sonido' : 'Silenciar',
            onPressed: _toggleSound,
            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
          ),
        ),
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
      VideoPlatform.local => 'Local',
      VideoPlatform.nasa => 'NASA',
      VideoPlatform.archive => 'Internet Archive',
      VideoPlatform.wikimedia => 'Wikimedia Commons',
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
            const Icon(
              Icons.music_note,
              size: 15,
              color: AppColors.textPrimary,
            ),
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
