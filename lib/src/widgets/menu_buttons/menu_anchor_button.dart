import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_utils.dart';
import 'package:dfc_flutter/src/widgets/triangle_painter.dart';
import 'package:flutter/material.dart';

class MenuAnchorButton extends StatelessWidget {
  const MenuAnchorButton({
    required this.menuData,
    // one must be set
    this.icon,
    this.title,
    this.widget,
    // tooltip only used for icons
    this.tooltip,
    this.color,
  });

  final Widget? icon;
  final String? title;
  final List<MenuButtonBarItemData> menuData;
  final String? tooltip;
  final Color? color;
  final Widget? widget;

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
        if (title != null) {
          return TextButton(
            onPressed: () => _onPressed(controller),
            child: _MenuTextContents(title!),
          );
        }

        if (icon != null) {
          return IconButton(
            color: color,
            onPressed: () => _onPressed(controller),
            icon: icon!,
            tooltip: tooltip,
          );
        }

        if (widget != null) {
          return InkWell(
            onTap: () => _onPressed(controller),
            child: widget,
          );
        }

        return const Text('icon/title/wiget null');
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
