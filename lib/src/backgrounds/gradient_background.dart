import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/backgrounds/gradient_painter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    required this.startColor,
    required this.endColor,
  });

  final Widget child;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _buildPainter(context)),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _buildPainter(BuildContext context) {
    final tween = Tween<double>(
      begin: 0,
      end: 1,
    );

    return MirrorAnimation<double>(
      tween: tween,
      duration: const Duration(seconds: 2),
      builder: (BuildContext context, _, double value) {
        return CustomPaint(
          painter: GradientPainter(
              value: value, startColor: startColor, endColor: endColor),
        );
      },
    );
  }
}

// Create enum that defines the animated properties
enum _AniProps { startColor, endColor }

class GradientBackground4 extends StatelessWidget {
  GradientBackground4({
    required this.child,
    required this.startColor1,
    required this.endColor1,
    required this.startColor2,
    required this.endColor2,
  });

  final Widget child;
  final Color startColor1;
  final Color endColor1;
  final Color startColor2;
  final Color endColor2;

  // Specify your tween
  final _tween = MultiTween<_AniProps>()
    ..add(_AniProps.startColor, Colors.red.tweenTo(Colors.blue), 3.seconds)
    ..add(_AniProps.endColor, Colors.red.tweenTo(Colors.blue), 3.seconds);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: MirrorAnimation<MultiTweenValues<_AniProps>>(
            tween: _tween, // Pass in tween
            duration: _tween.duration, // Obtain duration from MultiTween
            builder: (context, child, value) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      value.get(_AniProps.startColor),
                      value.get(_AniProps.endColor)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
