import 'dart:math';

import 'package:dfc_flutter/src/backgrounds/animation_timer.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class ParticleBackground extends StatelessWidget {
  const ParticleBackground({
    required this.child,
    required this.color,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(child: Particles(30, color)),
        Positioned.fill(child: child),
      ],
    );
  }
}

class Particles extends StatefulWidget {
  const Particles(
    this.numberOfParticles,
    this.color,
  );

  final int numberOfParticles;
  final Color color;

  @override
  State<Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<Particles> {
  final Random random = Random();

  final List<ParticleModel> particles = [];

  @override
  void initState() {
    List.generate(widget.numberOfParticles, (index) {
      particles.add(ParticleModel(random));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoopAnimation<int>(
      tween: ConstantTween(1),
      builder: (context, child, value) {
        final time =
            DateTime.now().duration(); // Duration() passed since 01.01.1970

        _simulateParticles(time);

        return CustomPaint(
          painter: ParticlePainter(particles, time, widget.color),
        );
      },
    );
  }

  void _simulateParticles(Duration time) {
    for (final particle in particles) {
      particle.updateParticle(time);
    }
  }
}

enum _AniProps { x, y }

class ParticleModel {
  ParticleModel(this.random) {
    restart();
  }
  late MultiTween<_AniProps> _tween;

  late double size;
  Random random;
  late double rando;
  AnimationTimer timer = AnimationTimer();

  void restart({Duration time = Duration.zero}) {
    final startPosition = Offset(-0.2 + 1.4 * random.nextDouble(), 1.2);
    final endPosition = Offset(-0.2 + 1.4 * random.nextDouble(), -0.2);
    final duration = Duration(milliseconds: 10000 + random.nextInt(20000));

    _tween = MultiTween<_AniProps>()
      ..add(
        _AniProps.x,
        Tween<double>(begin: startPosition.dx, end: endPosition.dx),
        duration,
        Curves.easeInOutSine,
      )
      ..add(
        _AniProps.y,
        Tween<double>(begin: startPosition.dy, end: endPosition.dy),
        duration,
        Curves.easeIn,
      );

    timer.restart(duration);

    rando = random.nextDouble();
    size = 0.1 + rando * 0.5;
  }

  void updateParticle(Duration time) {
    if (timer.progress(time) == 1.0) {
      restart(time: time);
    }
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles, this.time, this.color);

  final List<ParticleModel> particles;
  final Duration time;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final progress = particle.timer.progress(time);
      final animation = particle._tween.transform(progress);

      final position = Offset(
        animation.get<double>(_AniProps.x) * size.width,
        animation.get<double>(_AniProps.y) * size.height,
      );

      final int alpha = 30 + (50 * particle.rando).toInt();

      final paint = Paint()
        ..shader = RadialGradient(
          radius: 5,
          colors: [color.withAlpha(alpha ~/ 5), color.withAlpha(alpha)],
          stops: const [0, 0.4],
        ).createShader(
          Rect.fromCenter(
            center: position,
            width: size.width * 0.2 * particle.size,
            height: size.width * 0.2 * particle.size,
          ),
        );

      canvas.drawCircle(position, size.width * 0.2 * particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
