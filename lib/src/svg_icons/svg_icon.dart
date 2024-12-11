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
  });

  final double? size;
  final Color? color;
  final BoxFit fit;
  final bool allowDrawingOutsideViewBox;
  final String svg;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    Color svgColor = color ?? Colors.black;

    // if no color passed in, use the current theme color
    if (color == null) {
      svgColor = iconTheme.color ?? Colors.black;
    }

    final double iconOpacity = iconTheme.opacity ?? 1.0;
    if (iconOpacity != 1.0) {
      svgColor = svgColor.withValues(alpha: iconOpacity);
    }

    return SizedBox(
      height: size,
      width: size,
      child: SvgPicture.string(
        svg,
        colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
        width: size,
        fit: fit,
        allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      ),
    );
  }
}
