import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  late RiveAnimationController<dynamic> _controller;

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('SlideThem');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: RiveAnimation.asset(
        'assets/animations/loading.flr',
        // color: Theme.of(context).primaryColor,
        controllers: [_controller],
        // Update the play state when the widget's initialized
        // onInit: (_) => setState(() { _isPlaying = false}),
      ),
    );
  }
}
