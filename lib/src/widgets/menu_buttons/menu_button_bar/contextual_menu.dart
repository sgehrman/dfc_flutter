import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

class ContextualMenu extends StatefulWidget {
  const ContextualMenu({required this.buildMenu, required this.child});

  final List<MenuButtonBarItemData> Function() buildMenu;
  final Widget child;

  @override
  State<ContextualMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextualMenu> {
  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: widget.buildMenu(),
    );

    return DFCMenuAnchor(
      menuChildren: menuChildren,
      child: widget.child,
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      builder: (
        context,
        controller,
        child,
      ) {
        return InkWell(
          onSecondaryTapDown: (details) =>
              _handleRightClick(details, controller),
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
              if (controller.isOpen) {
                controller.close();
              }
            }
          },
          child: child,
        );
      },
    );
  }

  void _handleRightClick(TapDownDetails details, MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open(position: details.localPosition);
    }
  }
}
