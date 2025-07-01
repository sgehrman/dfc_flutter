import 'package:dfc_flutter/src/widgets/df_tool_tip/df_tooltip.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

class MenuPopupButton extends StatefulWidget {
  const MenuPopupButton({
    required this.child,
    required this.buildMenu,
    this.radius = Material.defaultSplashRadius,
    this.tooltip = '',
    this.alignment,
  });

  final Widget child;
  final List<MenuButtonBarItemData> Function() buildMenu;
  final double radius;
  final String tooltip;
  final Alignment? alignment;

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

    return DFTooltip(
      message: widget.tooltip,
      child: DFCMenuAnchor(
        menuChildren: menuChildren,
        style: MenuStyle(alignment: widget.alignment),
        builder: (
          context,
          controller,
          child,
        ) {
          return InkResponse(
            radius: widget.radius,
            onTapDown: (details) => _handleClick(details, controller),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
