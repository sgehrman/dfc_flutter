import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:flutter/material.dart';

class MenuPopupButton extends StatefulWidget {
  const MenuPopupButton({
    required this.child,
    required this.buildMenu,
    this.radius = Material.defaultSplashRadius,
    this.tooltip = '',
  });

  final Widget child;
  final List<MenuButtonBarItemData> Function() buildMenu;
  final double radius;
  final String tooltip;

  @override
  State<MenuPopupButton> createState() => _MenuPopupButtonState();
}

class _MenuPopupButtonState extends State<MenuPopupButton> {
  void _handleClick(TapDownDetails details, MenuController controller) {
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
      menuData: widget.buildMenu(),
    );

    return ToolTip(
      message: widget.tooltip,
      child: MenuAnchor(
        menuChildren: menuChildren,
        builder: (
          BuildContext context,
          MenuController controller,
          Widget? child,
        ) {
          return InkResponse(
            radius: widget.radius,
            onTapDown: (details) => _handleClick(details, controller),
            child: widget.child,
          );
        },
      ),
    );
  }
}
