import 'dart:math' as math;

import 'package:cinemapedia/config/helpers/startup_metrics.dart';
import 'package:cinemapedia/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// One-shot launch overlay; the application and its requests load underneath.
class CinematicSplashScreen extends StatefulWidget {
  const CinematicSplashScreen({required this.child, super.key});
  final Widget child;

  @override
  State<CinematicSplashScreen> createState() => _CinematicSplashScreenState();
}

class _CinematicSplashScreenState extends State<CinematicSplashScreen>
    with SingleTickerProviderStateMixin {
  // One central 3-second timeline: .0-.5 particles, .5-1.2 swirl,
  // 1.2-2.1 formation, 2.1-2.6 flash and 2.6-3.0 hand-off.
  static const _duration = Duration(seconds: 3);
  late final AnimationController _controller;
  var _finished = false;
  var _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          StartupMetrics.mark('intro_completed');
          setState(() => _finished = true);
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reduceMotion = MediaQuery.disableAnimationsOf(context);
      // No artificial delay for reduced motion; retain only a brief reveal.
      _controller.value = _reduceMotion ? .82 : 0;
      _controller.forward();
      StartupMetrics.mark('particles_started');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;
    return Stack(fit: StackFit.expand, children: [
      AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _fade(_controller.value, _Timeline.transitionStart, 1),
          child: child,
        ),
      ),
      AbsorbPointer(
        child: AnimatedBuilder(
          animation: _controller,
          child: _CinematicScene(
            controller: _controller,
            reduceMotion: _reduceMotion,
          ),
          builder: (context, child) => Opacity(
            opacity: 1 - _fade(_controller.value, _Timeline.transitionStart, 1),
            child: child,
          ),
        ),
      ),
    ]);
  }
}

abstract final class _Timeline {
  static const particleEnd = 1 / 6;
  static const swirlEnd = .4;
  static const formationEnd = .7;
  static const flashEnd = 13 / 15;
  static const transitionStart = flashEnd;
}

class _CinematicScene extends StatelessWidget {
  const _CinematicScene({required this.controller, required this.reduceMotion});
  final Animation<double> controller;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black,
        child: Stack(fit: StackFit.expand, children: [
          RepaintBoundary(
            child: CustomPaint(
              // Particle repaint is driven directly by the controller, rather
              // than rebuilding the entire scene on every animation tick.
              painter: _ParticleFieldPainter(controller, reduceMotion),
              isComplex: true,
              willChange: true,
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) => _LogoAndCopy(
              progress: controller.value,
              reduceMotion: reduceMotion,
            ),
          ),
        ]),
      );
}

class _LogoAndCopy extends StatelessWidget {
  const _LogoAndCopy({required this.progress, required this.reduceMotion});
  final double progress;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final logoIn = Curves.easeOutCubic.transform(
      _fade(progress, _Timeline.swirlEnd, _Timeline.formationEnd),
    );
    final titleIn = Curves.easeOut.transform(
      _fade(progress, _Timeline.formationEnd, .8),
    );
    final flash = _bell(progress, _Timeline.formationEnd, _Timeline.flashEnd);
    return Stack(fit: StackFit.expand, children: [
      Center(
        child: Transform.translate(
          offset: Offset(0, (1 - logoIn) * 18),
          child: Transform.scale(
            scale: .92 + (.08 * logoIn),
            child: Opacity(
              opacity: logoIn,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  // Smaller blur preserves the glow with lower GPU cost.
                  boxShadow: [BoxShadow(
                    color: const Color(0xFF00BFFF)
                        .withValues(alpha: .18 + (.22 * flash)),
                    blurRadius: 20 + (16 * flash),
                    spreadRadius: 1 + (2 * flash),
                  )],
                ),
                child: Image.asset('assets/icon/cinemapedia.png', width: 196,
                    height: 196, filterQuality: FilterQuality.medium),
              ),
            ),
          ),
        ),
      ),
      if (!reduceMotion) _HorizontalFlash(progress: progress),
      Align(
        alignment: const Alignment(0, .64),
        child: Opacity(
          opacity: titleIn,
          child: Transform.translate(
            offset: Offset(0, (1 - titleIn) * 12),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFF00E5FF)],
                ).createShader(bounds),
                child: const Text('230308', style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700,
                  letterSpacing: 5.1,
                )),
              ),
              const SizedBox(height: 10),
              Text(context.l10n.splashWelcome, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: .8),
                      fontSize: 14, letterSpacing: .7)),
            ]),
          ),
        ),
      ),
    ]);
  }
}

class _HorizontalFlash extends StatelessWidget {
  const _HorizontalFlash({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    final reveal = Curves.easeOut.transform(
      _fade(progress, _Timeline.formationEnd, _Timeline.flashEnd),
    );
    if (reveal == 0) return const SizedBox.shrink();
    final width = MediaQuery.sizeOf(context).width;
    return IgnorePointer(
      child: Transform.translate(
        offset: Offset((-width * 1.2) + (width * 2.4 * reveal), -18),
        child: Center(
          child: Container(
            width: 56,
            height: 210,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [
              Colors.transparent,
              const Color(0xFF00BFFF).withValues(alpha: .1),
              Colors.white.withValues(alpha: .64),
              const Color(0xFF00BFFF).withValues(alpha: .1),
              Colors.transparent,
            ])),
          ),
        ),
      ),
    );
  }
}

/// Pre-seeded, batched canvas particles. There are no particle widgets and no
/// random generation in paint(). Count is lowered for reduced-motion devices.
class _ParticleFieldPainter extends CustomPainter {
  _ParticleFieldPainter(this.animation, this.reduceMotion)
      : _particles = List<_Particle>.generate(
          reduceMotion ? 100 : 320, _Particle.fromIndex, growable: false),
        _trails = Paint()..strokeCap = StrokeCap.round,
        _dots = Paint(),
        _ambient = Paint(),
        super(repaint: animation);

  final Animation<double> animation;
  final bool reduceMotion;
  final List<_Particle> _particles;
  final Paint _trails;
  final Paint _dots;
  final Paint _ambient;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    final center = Offset(size.width / 2, size.height * .44);
    final radius = size.shortestSide * .34;
    final birth = Curves.easeOutCubic.transform(_fade(progress, 0, _Timeline.particleEnd));
    final swirl = Curves.easeInCubic.transform(_fade(progress, _Timeline.particleEnd, _Timeline.swirlEnd));
    final form = Curves.easeInOutCubic.transform(_fade(progress, _Timeline.swirlEnd, _Timeline.formationEnd));
    final fadeOut = 1 - _fade(progress, _Timeline.flashEnd, 1);
    _ambient.color = const Color(0xFF102A56).withValues(
      alpha: .16 * birth * (1 - _fade(progress, _Timeline.formationEnd, 1)));
    canvas.drawCircle(center, size.shortestSide * .58, _ambient);

    // Keep the visual density on large displays while reducing raster work on
    // compact phones. The particle metadata is still precomputed once.
    final activeCount = reduceMotion
        ? 100
        : size.shortestSide < 400
            ? 240
            : _particles.length;
    for (var particleIndex = 0; particleIndex < activeCount; particleIndex++) {
      final particle = _particles[particleIndex];
      final edge = Offset((particle.left ? -1.15 : 1.15) * size.width,
          (particle.edgeY - .5) * 1.45 * size.height);
      final angle = particle.angle + (progress * math.pi * (4.2 + particle.depth * 4.6));
      final helixRadius = radius * (.25 + particle.seed * .98) * (1 - .5 * form);
      final turbulence = reduceMotion ? Offset.zero : Offset(
        math.sin(progress * 30 + particle.index) * 7 * (1 - form),
        math.cos(progress * 24 + particle.index * .7) * 6 * (1 - form));
      final orbit = center + Offset(math.cos(angle) * helixRadius,
          math.sin(angle) * helixRadius * (.42 + particle.depth * .22)) + turbulence;
      final arrival = Offset.lerp(edge, orbit, birth) ?? orbit;
      final target = center + Offset(
        particle.core ? (particle.targetX * .16 + .01) * radius
            : (particle.targetX - .5) * radius * 1.7,
        particle.core ? (particle.targetY - .5) * radius * .26
            : ((particle.upper ? -.45 : .44) + (particle.targetY - .5) * .12) * radius);
      final position = Offset.lerp(arrival, target, form) ?? orbit;
      final alpha = ((.20 + .76 * birth) * fadeOut *
              (.55 + .45 * particle.depth) *
              255)
          .round();
      final color = particle.color.withAlpha(alpha);
      final dotRadius = (.55 + particle.depth * 1.75) * (1 + .35 * swirl);
      _dots.color = color;
      if (swirl > .04 && particle.depth > .52 && particle.index.isEven) {
        _trails
          ..color = color.withValues(alpha: color.a * .28)
          ..strokeWidth = dotRadius * .7;
        canvas.drawLine(Offset(position.dx - math.cos(angle) * 9 * swirl,
            position.dy - math.sin(angle) * 4 * swirl), position, _trails);
      }
      canvas.drawCircle(position, dotRadius, _dots);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticleFieldPainter old) =>
      old.animation != animation || old.reduceMotion != reduceMotion;
}

class _Particle {
  const _Particle({required this.index, required this.seed, required this.depth,
      required this.angle, required this.edgeY, required this.targetX,
      required this.targetY, required this.left, required this.core,
      required this.upper, required this.color});

  factory _Particle.fromIndex(int index) {
    final seed = _hash(index);
    final depth = .22 + (_hash(index + 83) * .78);
    return _Particle(index: index, seed: seed, depth: depth, angle: seed * math.pi * 2,
      edgeY: _hash(index + 31), targetX: _hash(index + 121), targetY: _hash(index + 257),
      left: seed < .5, core: index % 5 == 0, upper: index % 3 == 0,
      color: index % 11 == 0 ? const Color(0xFF00E5FF)
          : depth > .75 ? const Color(0xFF00BFFF) : const Color(0xFF007BFF));
  }
  final int index;
  final double seed, depth, angle, edgeY, targetX, targetY;
  final bool left, core, upper;
  final Color color;
}

double _hash(int value) {
  final result = math.sin(value * 12.9898) * 43758.5453;
  return result - result.floorToDouble();
}
double _fade(double value, double start, double end) =>
    ((value - start) / (end - start)).clamp(0.0, 1.0).toDouble();
double _bell(double value, double start, double end) =>
    math.sin(_fade(value, start, end) * math.pi);
