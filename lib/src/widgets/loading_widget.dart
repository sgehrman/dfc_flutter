import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.fourRotatingDots(
        color: Theme.of(context).primaryColor,
        size: 64,
      ),

      // child: SizedBox(
      //   height: 64,
      //   width: 64,
      //   child: CircularProgressIndicator(
      //     color: Theme.of(context).primaryColor,
      //     strokeWidth: 6,
      //   ),
      // ),
    );
  }
}
