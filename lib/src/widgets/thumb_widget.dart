import 'package:dfc_flutter/src/extensions/color_ext.dart';
import 'package:dfc_flutter/src/utils/rect_clipper.dart';
import 'package:flutter/material.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({
    required this.index,
    required this.selectedIndex,
    this.iconSize = 32,
    this.opacity = 1,
  });

  final int index; // 0-3
  final int? selectedIndex; // 0-3 or null
  final double iconSize;
  final double opacity;

  Widget _thumb(int index) {
    const Color unselectedColor = Color.fromRGBO(180, 180, 180, 1);

    IconData icon;
    IconData outlinedIcon;

    final bool isSelected = selectedIndex == index;

    Color? iconColor;
    final double xOffset = (iconSize / 5).roundToDouble();
    double yOffset = 1;

    if (index < 2) {
      icon = Icons.thumb_down;
      outlinedIcon = Icons.thumb_down;

      iconColor = Colors.red[600];
    } else {
      icon = Icons.thumb_up;
      outlinedIcon = Icons.thumb_up;
      yOffset *= -1;

      iconColor = Colors.green[600];
    }

    final isDouble = index == 0 || index == 3;

    Color? firstIconColor = isSelected ? iconColor : unselectedColor;
    if (isDouble) {
      firstIconColor = firstIconColor!.darker(factor: 0.05);
    }

    return Padding(
      // leave space since double icons grow leftward
      padding: EdgeInsets.only(left: xOffset),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            isSelected ? icon : outlinedIcon,
            color: firstIconColor,
            size: iconSize,
          ),
          // white shadow
          Visibility(
            visible: isDouble,
            child: Positioned(
              right: xOffset - 1,
              bottom: yOffset,
              child: ClipRect(
                clipper: const RectClipper(),
                child: Icon(
                  isSelected ? icon : outlinedIcon,
                  color: Colors.black54,
                  size: iconSize,
                ),
              ),
            ),
          ),
          Visibility(
            visible: isDouble,
            child: Positioned(
              right: xOffset,
              bottom: yOffset,
              child: Icon(
                isSelected ? icon : outlinedIcon,
                color: isSelected ? iconColor! : unselectedColor,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: opacity, child: _thumb(index));
  }
}
