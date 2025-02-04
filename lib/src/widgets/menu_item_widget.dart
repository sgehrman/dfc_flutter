import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    required this.name,
    this.iconWidget,
    this.iconData,
    this.tooltip,
  });

  // we want to standardize the iconSize, so just pass in the iconData
  // if you are using another widget (like SvgIcon) pass in the iconWidget
  final IconData? iconData;
  final Widget? iconWidget;

  final String name;
  final String? tooltip;

  static const double iconSize = 24;

  // use this for items without an icon, but needs to line up with items that do (checkmarks)
  static Widget blankIcon = const SizedBox(height: iconSize, width: iconSize);

  @override
  Widget build(BuildContext context) {
    Widget leading = const SizedBox();
    if (iconData != null) {
      leading = Icon(iconData, size: iconSize);
    } else if (iconWidget != null) {
      leading = iconWidget!;
    }

    return Tooltip(
      message: tooltip,
      child: ListTile(
        leading: leading,
        title: Text(
          name,
        ),
      ),
    );
  }
}
