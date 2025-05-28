import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgAsset extends StatelessWidget {
  const SvgAsset(
    this.assetPath, {
    this.package,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final String? package;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      package: package,
      fit: fit,
    );
  }
}
