import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    required this.color,
    this.delay = const Duration(milliseconds: 1000),
    this.size = 64,
  });

  final Color color;
  final double size;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: size * 0.1,
        )
            .animate()
            .effect(
              curve: Curves.easeIn,
              delay: delay,
              duration: const Duration(milliseconds: 300),
            )
            .fadeIn(begin: 0),
      ),
    );
  }
}

// ==================================================

class AnimatedLoader extends StatelessWidget {
  const AnimatedLoader({this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Theme.of(context).colorScheme.primary,
        size: size,
      ),
    );
  }
}
