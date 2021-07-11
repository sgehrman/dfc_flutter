import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: FlareActor('packages/dfc_flutter/assets/animations/loading.flr',
          color: Theme.of(context).primaryColor, animation: 'SlideThem'),
    );
  }
}
