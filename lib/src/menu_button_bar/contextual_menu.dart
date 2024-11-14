import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

class ContextualMenu extends StatefulWidget {
  const ContextualMenu({
    required this.buildMenu,
    required this.child,
  });

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

    return MenuAnchor(
      menuChildren: menuChildren,
      consumeOutsideTap: true,
      child: widget.child,
      onOpen: () {
        setState(() {});
      },
      onClose: () {
        setState(() {});
      },
      builder: (
        BuildContext context,
        MenuController controller,
        Widget? builderChild,
      ) {
        final HitTestBehavior behavior = controller.isOpen
            ? HitTestBehavior.opaque
            : HitTestBehavior.deferToChild;

        final onTap = controller.isOpen
            ? () {
                controller.close();
              }
            : null;

        return GestureDetector(
          onSecondaryTapDown: (details) {
            if (controller.isOpen) {
              controller.close();
              return;
            }

            controller.open(position: details.localPosition);
          },
          onTap: onTap,
          behavior: behavior,
          child: widget.child,
        );
      },
    );
  }
}
