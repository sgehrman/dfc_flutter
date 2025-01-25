import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_anchor_button_utils.dart';
import 'package:flutter/material.dart';

class MenuAnchorButton extends StatelessWidget {
  const MenuAnchorButton({
    required this.menuData,
    // one must be set
    this.icon,
    this.title,
    this.widget,
    // all bellow, only used for icons
    this.tooltip,
    this.color,
    this.filledButton = false,
    this.small = false,
  });

  final Widget? icon;
  final String? title;
  final List<MenuButtonBarItemData> menuData;
  final String? tooltip;
  final Color? color;
  final Widget? widget;
  final bool filledButton;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final menuItems = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: menuData,
    );

    return DFCMenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return MenuAnchorButtonContents(
          controller: controller,
          color: color,
          icon: icon,
          title: title,
          tooltip: tooltip,
          widget: widget,
          filledButton: filledButton,
          small: small,
        );
      },
      menuChildren: menuItems,
    );
  }
}
