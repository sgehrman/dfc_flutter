import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

// an contextual menu and InkWell combined
// right click pops a menu, left click calls onTap

class ContextualInkWell extends StatelessWidget {
  const ContextualInkWell({
    required this.buildMenu,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });

  final List<MenuButtonBarItemData> Function() buildMenu;
  final Widget child;
  final void Function() onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: buildMenu(),
    );

    return MenuAnchor(
      menuChildren: menuChildren,
      consumeOutsideTap: true,
      child: child,
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return InkWell(
          borderRadius: borderRadius,
          // focusColor seems to get set on a right click? it get focused?
          focusColor: Colors.green,
          splashColor: Colors.blue,
          highlightColor: Colors.yellow,
          hoverColor: Colors.red,
          onSecondaryTapDown: (details) {
            if (controller.isOpen) {
              controller.close();

              return;
            }

            controller.open(position: details.localPosition);
          },
          onTap: () {
            if (controller.isOpen) {
              controller.close();

              return;
            }

            onTap();
          },
          child: child,
        );
      },
    );
  }
}
