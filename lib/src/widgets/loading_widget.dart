import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    this.size = 64,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: size * 0.1,
        ),
      ),
    );
  }
}

class AnimatedLoader extends StatelessWidget {
  const AnimatedLoader({this.size = 140});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}
