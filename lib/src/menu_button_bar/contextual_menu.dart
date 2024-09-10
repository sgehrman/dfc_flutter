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
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final menuChildren = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: widget.buildMenu(),
    );

    return GestureDetector(
      onSecondaryTapDown: _handleRightClick,
      // don't eat the mouse down if menu isn't open, let it fall through to the child
      onTapDown:
          _menuController.isOpen ? (details) => _menuController.close() : null,
      child: MenuAnchor(
        controller: _menuController,
        menuChildren: menuChildren,
        child: widget.child,
      ),
    );
  }

  void _handleRightClick(TapDownDetails details) {
    if (_menuController.isOpen) {
      _menuController.close();
      return;
    }

    _menuController.open(position: details.localPosition);
  }
}
