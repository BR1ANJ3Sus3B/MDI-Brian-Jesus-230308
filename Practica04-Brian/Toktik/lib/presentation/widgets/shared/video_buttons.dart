import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:practica04_brian/config/helpers/human_formats.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';

/// Columna de acciones superpuesta al video: avatar con boton de seguir, like,
/// comentarios, compartir, guardar y audio.
///
/// El like es interactivo: alterna entre rojo y blanco, suma o resta 1 y
/// dispara un pulso al activarse.
class VideoButtons extends StatefulWidget {
  final VideoPost video;

  const VideoButtons({super.key, required this.video});

  @override
  State<VideoButtons> createState() => _VideoButtonsState();
}

class _VideoButtonsState extends State<VideoButtons> {
  late bool _isLiked;
  late int _likes;

  @override
  void initState() {
    super.initState();
    _isLiked = false;
    _likes = widget.video.likes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // El like se envuelve en un pulso solo mientras esta activado.
    Widget likeButton = _ActionButton(
      icon: _isLiked ? Icons.favorite : Icons.favorite_border,
      iconColor: _isLiked ? AppColors.primary : AppColors.textPrimary,
      label: HumanFormats.humanReadableNumber(_likes.toDouble()),
      onTap: _toggleLike,
    );

    if (_isLiked) {
      likeButton = Pulse(child: likeButton);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Avatar(userName: widget.video.userName),
        const SizedBox(height: 16),
        likeButton,
        const SizedBox(height: 14),
        _ActionButton(
          icon: Icons.mode_comment_outlined,
          label: HumanFormats.humanReadableNumber((_likes ~/ 12).toDouble()),
          onTap: _noop,
        ),
        const SizedBox(height: 14),
        _ActionButton(
          icon: Icons.ios_share,
          label: HumanFormats.humanReadableNumber((_likes ~/ 30).toDouble()),
          onTap: _noop,
        ),
        const SizedBox(height: 14),
        const _ActionButton(icon: Icons.bookmark_border, onTap: _noop),
        const SizedBox(height: 16),
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 4),
          child: _AlbumCover(userName: widget.video.userName),
        ),
      ],
    );
  }
}

/// Accion todavia no implementada: no rompe el flujo del video.
void _noop() {}

/// Inicial del autor a partir de su nombre: "brain.dev" -> "B".
String _initialOf(String userName) {
  final String cleaned = userName.replaceAll('@', '').trim();
  return cleaned.isEmpty ? '?' : cleaned[0].toUpperCase();
}

/// Avatar circular con el boton de seguir superpuesto.
class _Avatar extends StatelessWidget {
  final String userName;

  const _Avatar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 54,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
              gradient: const LinearGradient(
                colors: <Color>[AppColors.secondary, AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              _initialOf(userName),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          // Boton de seguir, medio colgado del avatar.
          Positioned(
            bottom: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: const Icon(Icons.add, size: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Boton de accion: icono con sombra y contador debajo.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    // `InkResponse` necesita un ancestro `Material`. Como estos botones se
    // superponen al video (sin Material debajo), se aporta uno transparente
    // para que el efecto de ripple funcione sin tapar el video.
    return Material(
      type: MaterialType.transparency,
      child: Semantics(
        button: true,
        label: label ?? 'accion',
        child: InkResponse(
          onTap: onTap,
          radius: 26,
          splashColor: AppColors.primary.withValues(alpha: 0.25),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: iconColor ?? AppColors.textPrimary,
                  shadows: const [
                    Shadow(color: Color(0x99000000), blurRadius: 8),
                  ],
                ),
                if (label != null && label!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      shadows: [
                        Shadow(color: Color(0x99000000), blurRadius: 6),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Miniatura de disco del boton de audio, con la inicial del autor.
class _AlbumCover extends StatelessWidget {
  final String userName;

  const _AlbumCover({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: Colors.white, width: 5),
      ),
      child: Container(
        width: 18,
        height: 18,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: Text(
          _initialOf(userName),
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}