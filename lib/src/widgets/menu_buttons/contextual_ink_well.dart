import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:flutter/material.dart';

// an contextual menu and InkWell combined
// right click pops a menu, left click calls onTap

class ContextualInkWell extends StatelessWidget {
  const ContextualInkWell({
    required this.buildMenu,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.useGestureDetector = false,
  });

  final List<MenuButtonBarItemData> Function() buildMenu;
  final Widget child;
  final void Function() onTap;
  final BorderRadius? borderRadius;
  final bool useGestureDetector;

  void _handleLeftClick(MenuController controller, Widget? child) {
    if (controller.isOpen) {
      controller.close();

      return;
    }

    onTap();
  }

  void _handleRightClick(
    TapDownDetails details,
    MenuController controller,
    Widget? child,
  ) {
    if (controller.isOpen) {
      controller.close();

      return;
    }

    controller.open(position: details.localPosition);
  }

  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: buildMenu(),
    );

    return DFCMenuAnchor(
      menuChildren: menuChildren,
      consumeOutsideTap: true,
      child: child,
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? child,
      ) {
        if (useGestureDetector) {
          return GestureDetector(
            onSecondaryTapDown: (details) {
              _handleRightClick(details, controller, child);
            },
            onTap: () {
              _handleLeftClick(controller, child);
            },
            child: child,
          );
        }
        return InkWell(
          borderRadius: borderRadius,
          onSecondaryTapDown: (details) {
            _handleRightClick(details, controller, child);
          },
          onTap: () {
            _handleLeftClick(controller, child);
          },
          child: child,
        );
      },
    );
  }
}
