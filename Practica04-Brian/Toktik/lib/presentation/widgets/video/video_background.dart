import 'package:flutter/material.dart';
import 'package:practica04_brian/config/theme/app_colors.dart';

/// Degradado a pantalla completa usado para dar legibilidad al texto que se
/// superpone sobre el video.
///
/// Siempre devuelve un `Positioned.fill` envuelto en `IgnorePointer`, para que
/// el degradado no intercepte los toques destinados al reproductor.
class VideoBackground extends StatelessWidget {
  final List<Color> colors;
  final List<double> stops;
  final Alignment begin;
  final Alignment end;

  /// Degradado superior, para la cabecera.
  const VideoBackground.top({
    super.key,
    this.colors = AppColors.topGradient,
    this.stops = AppColors.topGradientStops,
  }) : begin = Alignment.topCenter,
       end = Alignment.bottomCenter;

  /// Degradado inferior, para el autor y el caption.
  const VideoBackground.bottom({
    super.key,
    this.colors = AppColors.bottomGradient,
    this.stops = AppColors.bottomGradientStops,
  }) : begin = Alignment.topCenter,
       end = Alignment.bottomCenter;

  const VideoBackground({
    super.key,
    required this.colors,
    required this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  }) : assert(
         colors.length == stops.length,
         'stops and colors must have the same length',
       );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              stops: stops,
              begin: begin,
              end: end,
            ),
          ),
        ),
      ),
    );
  }
}