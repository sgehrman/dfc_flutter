import 'package:dfc_flutter/src/widgets/menu_buttons/dfc_menu_anchor.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_anchor_button_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

class MenuAnchorDynamicButton extends StatefulWidget {
  const MenuAnchorDynamicButton({
    required this.menuBuilder,
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
  final String? tooltip;
  final Color? color;
  final Widget? widget;
  final List<MenuButtonBarItemData> Function() menuBuilder;
  final bool filledButton;
  final bool small;

  @override
  State<MenuAnchorDynamicButton> createState() =>
      _MenuAnchorDynamicButtonState();
}

class _MenuAnchorDynamicButtonState extends State<MenuAnchorDynamicButton> {
  List<Widget> _menuItems = [];

  @override
  Widget build(BuildContext context) {
    if (_menuItems.isEmpty) {
      // need a dummy item otherwise not clickable
      _menuItems = [
        const MenuItemButton(
          child: Text(''),
        ),
      ];
    }

    return DFCMenuAnchor(
      onOpen: () {
        setState(() {
          _menuItems = MenuButtonBarUtils.buildMenuItems(
            context: context,
            menuData: widget.menuBuilder(),
          );
        });
      },
      builder: (context, controller, child) {
        return MenuAnchorButtonContents(
          controller: controller,
          color: widget.color,
          icon: widget.icon,
          title: widget.title,
          tooltip: widget.tooltip,
          widget: widget.widget,
          filledButton: widget.filledButton,
          small: widget.small,
        );
      },
      menuChildren: _menuItems,
    );
  }
}
