import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

// an contextual menu and InkWell combined
// right click pops a menu, left click calls onTap

class ContextualInkWell extends StatelessWidget {
  const ContextualInkWell({
    required this.buildMenu,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.disableHoverColor = false,
  });

  final List<MenuButtonBarItemData> Function() buildMenu;
  final Widget child;
  final void Function() onTap;
  final BorderRadius? borderRadius;
  final bool disableHoverColor;

  void _handleLeftClick(MenuController controller, Widget? child) {
    if (controller.isOpen) {
      controller.close();
    } else {
      onTap();
    }
  }

  void _handleRightClick(
    TapDownDetails details,
    MenuController controller,
  ) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open(position: details.localPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: buildMenu(),
    );

    return DFCMenuAnchor(
      menuChildren: menuChildren,
      child: child,
      builder: (
        context,
        controller,
        child,
      ) {
        return InkWell(
          focusColor: disableHoverColor ? Colors.transparent : null,
          hoverColor: disableHoverColor ? Colors.transparent : null,
          borderRadius: borderRadius,
          onSecondaryTapDown: (details) {
            _handleRightClick(details, controller);
          },
          onTapDown: (details) {
            // on mac, left click with control key down is a right click
            if (Utils.isControlKeyDown()) {
              _handleRightClick(details, controller);
            }
          },
          onTap: () {
            // on mac, left click with control key down is a right click
            // so don't send a left click if control key is down
            if (!Utils.isControlKeyDown()) {
              _handleLeftClick(controller, child);
            }
          },
          child: child,
        );
      },
    );
  }
}
