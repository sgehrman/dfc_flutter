import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.icon, {
    this.size = 24,
    this.fit = BoxFit.contain,
    this.allowDrawingOutsideViewBox = false,
    this.color = Colors.black,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.fastOutSlowIn,
  });

  final double size;
  final Color color;
  final BoxFit fit;
  final bool allowDrawingOutsideViewBox;
  final MainAxisAlignment mainAxisAlignment;
  final String icon;
  final Duration animationDuration;
  final Curve animationCurve;

  @override
  Widget build(BuildContext context) {
    String svgString = icon;

    if (Utils.isWeb) {
      String hexString = color.value.toRadixString(16).padLeft(6, '0');
      hexString = hexString.substring(2, hexString.length);

      String opacity = (color.opacity * 10).toInt().toString();
      opacity = '0.$opacity';

      svgString = svgString.replaceAll(
        'fill="#000000"',
        'fill-opacity="$opacity" fill="#$hexString"',
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        AnimatedContainer(
          height: size,
          width: size,
          duration: animationDuration,
          curve: animationCurve,
          child: SvgPicture.string(
            svgString,
            color: color,
            width: size,
            fit: fit,
            allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
          ),
        ),
      ],
    );
  }
}
