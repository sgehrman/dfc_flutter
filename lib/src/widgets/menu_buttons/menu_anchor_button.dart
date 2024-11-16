import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/triangle_painter.dart';
import 'package:flutter/material.dart';

class MenuAnchorButton extends StatelessWidget {
  const MenuAnchorButton({
    required this.icon,
    required this.menuData,
    this.title = '',
    this.tooltip,
  });

  final Widget icon;
  final String title;
  final List<MenuButtonBarItemData> menuData;
  final String? tooltip;

  void _onPressed(MenuController controller) {
    if (controller.isOpen) {
      controller.close();
    } else {
      controller.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = MenuButtonBarUtils.buildMenuItems(
      context: context,
      menuData: menuData,
    );

    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        if (title.isNotEmpty) {
          return TextButton(
            onPressed: () => _onPressed(controller),
            child: _MenuTextContents(title),
          );
        }

        return IconButton(
          onPressed: () => _onPressed(controller),
          icon: icon,
          tooltip: tooltip,
        );
      },
      menuChildren: menuItems,
    );
  }
}

// ==================================================================

class _MenuTextContents extends StatelessWidget {
  const _MenuTextContents(this.title);

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
