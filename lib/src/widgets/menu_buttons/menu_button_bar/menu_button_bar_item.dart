import 'package:dfc_flutter/src/widgets/df_tool_tip/df_tooltip.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_utils.dart';
import 'package:flutter/material.dart';

// Items for a MenuBar(), adds dynamic menu loading, tooltips and other stuff

class MenuButtonBarItem extends StatefulWidget {
  const MenuButtonBarItem({
    required this.child,
    required this.menuBuilder,
    this.tooltip = '',
  });

  MenuButtonBarItem.icon({
    required IconData iconData,
    required this.menuBuilder,
    this.tooltip = '',
    Color? color,
  }) : child = Icon(
          iconData,
          color: color,
        );

  final Widget child;
  final String tooltip;
  final List<MenuButtonBarItemData> Function() menuBuilder;

  @override
  State<MenuButtonBarItem> createState() => _MenuButtonBarItemState();
}

class _MenuButtonBarItemState extends State<MenuButtonBarItem> {
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

    return SubmenuButton(
      onOpen: () {
        setState(() {
          _menuItems = MenuButtonBarUtils.buildMenuItems(
            context: context,
            menuData: widget.menuBuilder(),
          );
        });
      },
      menuChildren: _menuItems,
      child: DFTooltip(message: widget.tooltip, child: widget.child),
    );
  }
}
