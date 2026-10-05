import 'package:flutter/material.dart';
import 'package:practica04_brian/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

/// Reproductor de video a pantalla completa con caption y gradiente.
///
/// `initialize()` se dispara una sola vez en `initState` (nunca dentro de
/// `build`, que se ejecuta en cada rebuild) y se refleja en el estado mediante
/// `_initialized` + `setState`.
class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
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
    _controller
      ..setLooping(true)
      ..setVolume(0)
      ..initialize()
          .then((_) {
        if (!mounted) return;
        setState(() {
          _initialized = true;
          _error = null;
        });
        _controller.play();
      })
          .catchError((Object error) {
        if (!mounted) return;
        setState(() {
          _initialized = false;
          _error = error;
        });
      });
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

          // Gradiente inferior para que el texto sea legible.
          VideoBackground(stops: const [0.8, 1.0]),

          // Caption del video.
          Positioned(
            bottom: 50,
            left: 20,
            child: _VideoCaption(caption: widget.caption),
          ),

          // Indicador de pausa.
          if (!_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 70,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(
        caption,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      ),
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
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.videocam_off_outlined,
                color: Colors.white38,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'No se pudo cargar el video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}