import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  const MenuItemWidget({
    required this.name,
    this.iconWidget,
    this.iconData,
    this.level = 0,
    this.tooltip,
  });

  // we want to standardize the iconSize, so just pass in the iconData
  // if you are using another widget (like SvgIcon) pass in the iconWidget
  final IconData? iconData;
  final Widget? iconWidget;

  final String name;
  final int level;
  final String? tooltip;

  static const double iconSize = 24;

  // use this for items without an icon, but needs to line up with items that do (checkmarks)
  static Widget blankIcon = const SizedBox(height: iconSize, width: iconSize);

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 10;
    const double levelPadding = 20;

    final contentPadding = EdgeInsets.only(
      right: horizontalPadding,
      left: horizontalPadding + (level * levelPadding),
    );

    Widget leading = const SizedBox();
    if (iconData != null) {
      leading = Icon(iconData, size: iconSize);
    } else if (iconWidget != null) {
      leading = iconWidget!;
    }

    return ToolTip(
      message: tooltip,
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: [
            leading,
            const SizedBox(
              width: 14,
            ),
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
