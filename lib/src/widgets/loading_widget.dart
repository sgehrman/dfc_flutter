import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    required this.color,
    this.size = 64,
  });

  final Color color;
  final double size;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // fades in so it's not jarring
    _colorTween = _controller.drive<Color?>(
      ColorTween(end: widget.color),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: CircularProgressIndicator(
          valueColor: _colorTween,
          strokeWidth: widget.size * 0.1,
        ),
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
        color: Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}
