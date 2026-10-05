import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:practica04_brian/config/helpers/human_formats.dart';
import 'package:practica04_brian/domain/entities/video_post.dart';

/// Columna de acciones que se superpone al video: likes, vistas y audio.
class VideoButtons extends StatelessWidget {
  final VideoPost video;

  const VideoButtons({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CustomIconButton(
          value: video.likes,
          iconColor: Colors.red,
          iconData: Icons.favorite,
        ),
        const SizedBox(height: 20),
        _CustomIconButton(
          value: video.views,
          iconData: Icons.remove_red_eye_outlined,
        ),
        const SizedBox(height: 20),
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: _CustomIconButton(
            value: 0,
            iconData: Icons.music_note_outlined,
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color color;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    Color? iconColor,
  }) : color = iconColor ?? Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(iconData, color: color, size: 30),
          tooltip: HumanFormats.humanReadableNumber(value.toDouble()),
        ),
        if (value > 0)
          Text(
            HumanFormats.humanReadableNumber(value.toDouble()),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
      ],
    );
  }
}