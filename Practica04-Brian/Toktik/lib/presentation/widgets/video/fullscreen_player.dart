import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';
import 'package:practica04_brian/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

/// Reproductor de video a pantalla completa.
///
/// `initialize()` se dispara una sola vez en `initState` (nunca dentro de
/// `build`, que se ejecuta en cada rebuild) y se refleja en el estado mediante
/// `_initialized` + `setState`.
class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;

  /// Autor y audio mostrados en el overlay inferior.
  final String userName;
  final String songName;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    this.userName = 'usuario',
    this.songName = 'sonido original',
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late final VideoPlayerController _controller;

  bool _initialized = false;
  Object? _error;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(widget.videoUrl);

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _controller.setLooping(true);
      await _controller.setVolume(0);
      await _controller.initialize();
      await _controller.play();

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
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_initialized) return;

    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return _ErrorVideo(message: widget.caption);

    if (!_initialized) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return GestureDetector(
      onTap: _togglePlayback,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // El video se centra y se ajusta al alto disponible manteniendo su
          // proporcion, sin deformarse.
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),

          // Degradado inferior para que el texto sea legible.
          const VideoBackground.bottom(),

          // Autor, caption y audio.
          Positioned(
            left: 16,
            right: 96,
            bottom: 24,
            child: _VideoInfo(
              caption: widget.caption,
              userName: widget.userName,
              songName: widget.songName,
            ),
          ),

          // Indicador de pausa: aparece al pausar con un toque.
          AnimatedOpacity(
            opacity: _initialized && !_controller.value.isPlaying ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 72,
                color: Color(0xB3FFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bloque inferior con el autor, la descripcion y el audio del video.
class _VideoInfo extends StatelessWidget {
  final String caption;
  final String userName;
  final String songName;

  const _VideoInfo({
    required this.caption,
    required this.userName,
    required this.songName,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            shadows: const [
              Shadow(color: Color(0x80000000), blurRadius: 4),
            ],
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

/// Se muestra cuando el asset no se puede cargar, en lugar de dejar la pantalla
/// en blanco o romper la app.
class _ErrorVideo extends StatelessWidget {
  final String message;

  const _ErrorVideo({required this.message});

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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam_off_outlined,
                  color: AppColors.textTertiary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No se pudo cargar el video',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}