import 'package:flutter/material.dart';

class RectClipper extends CustomClipper<Rect> {
  const RectClipper({
    this.clipLeft = true,
    this.percentage = .5,
  });

  final bool clipLeft;
  final double percentage;

  @override
  Rect getClip(Size size) {
    return clipLeft
        ? Rect.fromLTWH(size.width * percentage, 0, size.width, size.height)
        : Rect.fromLTWH(0, 0, size.width * percentage, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
