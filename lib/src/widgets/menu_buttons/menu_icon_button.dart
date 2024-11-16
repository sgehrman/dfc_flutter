import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

class MenuIconButton extends StatelessWidget {
  const MenuIconButton({
    required this.icon,
    required this.menuData,
    this.tooltip,
  });

  final Widget icon;
  final List<MenuButtonBarItemData> menuData;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final menuItems = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: menuData,
    );

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: icon,
          tooltip: tooltip,
        );
      },
      menuChildren: menuItems,
    );
  }
}
