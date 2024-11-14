import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

// an contextual menu and InkWell combined
// right click pops a menu, left click calls onTap

class ContextualInkWell extends StatefulWidget {
  const ContextualInkWell({
    required this.buildMenu,
    required this.child,
    required this.onTap,
  });

  final List<MenuButtonBarItemData> Function() buildMenu;
  final Widget child;
  final void Function() onTap;

  @override
  State<ContextualInkWell> createState() => _ContextInkWellState();
}

class _ContextInkWellState extends State<ContextualInkWell> {
  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: widget.buildMenu(),
    );

    return MenuAnchor(
      menuChildren: menuChildren,
      consumeOutsideTap: true,
      child: widget.child,
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        return InkWell(
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

            widget.onTap();
          },
          child: child,
        );
      },
    );
  }
}
