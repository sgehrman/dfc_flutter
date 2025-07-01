import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_styles.dart';
import 'package:flutter/material.dart';

class MenuButtonBar extends StatelessWidget {
  const MenuButtonBar({
    required this.barItems,
    this.transparent = true,
    super.key,
  });

  final List<MenuButtonBarItem> barItems;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: transparent
          ? MenuButtonBarStyles.transparentMenuBarStyle(context)
          : MenuButtonBarStyles.menuBarStyle(context),
      children: barItems,
    );
  }
}
