import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'package:dfc_flutter/src/svg_icons/bootstrap_svgs.dart';
export 'package:dfc_flutter/src/svg_icons/community_svgs.dart';
// for convience
export 'package:dfc_flutter/src/svg_icons/fontawesome_svgs.dart';
export 'package:dfc_flutter/src/svg_icons/material_svgs.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.svg, {
    this.size = 24,
    this.fit = BoxFit.contain,
    this.allowDrawingOutsideViewBox = false,
    this.color,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.fastOutSlowIn,
  });

  final double? size;
  final Color? color;
  final BoxFit fit;
  final bool allowDrawingOutsideViewBox;
  final MainAxisAlignment mainAxisAlignment;
  final String svg;
  final Duration animationDuration;
  final Curve animationCurve;

  String _webFix(
    String svg,
    Color svgColor,
  ) {
    String svgString = svg;

    String hexString = svgColor.value.toRadixString(16).padLeft(6, '0');
    hexString = hexString.substring(2, hexString.length);

    svgString = svgString.replaceAll(
      'fill="#000000"',
      'fill="#$hexString"',
    );

    // fill-opacity doesn't seem to work globally like the fill, so we add it to each path
    if (svgColor.opacity < 1.0) {
      String opacity = (svgColor.opacity * 10).toInt().toString();
      opacity = '0.$opacity';

      svgString = svgString.replaceAll(
        '<path ',
        '<path fill-opacity="$opacity" ',
      );

      svgString = svgString.replaceAll(
        '<rect ',
        '<rect fill-opacity="$opacity" ',
      );

      svgString = svgString.replaceAll(
        '<circle ',
        '<rect fill-opacity="$opacity" ',
      );

      svgString = svgString.replaceAll(
        '<polygon ',
        '<polygon fill-opacity="$opacity" ',
      );
    }

    return svgString;
  }

  @override
  Widget build(BuildContext context) {
    final String svgString = svg;

    Color svgColor = color ?? Colors.black;

    // if no color passed in, use the current theme color
    if (color == null) {
      svgColor = Theme.of(context).iconTheme.color ?? Colors.black;
    }

    // if (Utils.isWeb) {
    //   svgString = _webFix(svgString, svgColor);
    // }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: SvgPicture.string(
            svgString,
            color: svgColor,
            width: size,
            fit: fit,
            allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
          ),
        ),
      ],
    );
  }
}
