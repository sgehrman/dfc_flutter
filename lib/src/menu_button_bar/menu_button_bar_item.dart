import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_styles.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:dfc_flutter/src/widgets/triangle_painter.dart';
import 'package:flutter/material.dart';

class MenuButtonBarItem extends StatefulWidget {
  const MenuButtonBarItem({
    required this.child,
    required this.menuBuilder,
    this.round = false,
    this.iconSize = 24,
    this.tooltip = '',
  });

  MenuButtonBarItem.icon({
    required IconData iconData,
    required this.menuBuilder,
    this.tooltip = '',
    Color? color,
    this.iconSize = 24,
  })  : round = true,
        child = Icon(
          iconData,
          color: color,
        );

  final Widget child;
  final String tooltip;
  final List<MenuButtonBarItemData> Function() menuBuilder;
  final bool round;
  final double iconSize;

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

    return ToolTip(
      message: widget.tooltip,
      child: SubmenuButton(
        onOpen: () {
          setState(() {
            _menuItems = MenuButtonBarUtils.buildMenuItems(
              context: context,
              menuData: widget.menuBuilder(),
            );
          });
        },
        style: MenuButtonBarStyles.menuBarItemStyle(
          context: context,
          round: widget.round,
          iconSize: widget.iconSize,
        ),
        menuChildren: _menuItems,
        child: widget.child,
      ),
    );
  }
}

// =======================================================================

class MenuTextButton extends StatelessWidget {
  const MenuTextButton(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        TrianglePainter.downArrowIcon(
          context: context,
          padding: const EdgeInsets.only(left: 4, top: 4),
          height: 7,
          width: 11,
        ),
      ],
    );
  }
}
