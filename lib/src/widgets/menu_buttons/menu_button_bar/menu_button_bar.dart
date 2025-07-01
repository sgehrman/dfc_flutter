import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_buttons/menu_button_bar/menu_button_bar_item.dart';
import 'package:flutter/material.dart';

class MenuButtonBar extends StatelessWidget {
  const MenuButtonBar({
    required this.barItems,
    this.transparent = true,
    super.key,
  });

  final List<MenuButtonBarItem> barItems;
  final bool transparent;

  MenuStyle transparentMenuBarStyle(BuildContext context) {
    return MenuStyle(
      elevation: WidgetStateProperty.resolveWith<double>(
        (states) => 0,
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          return Colors.transparent;
        },
      ),
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
        (states) {
          return EdgeInsets.zero;
        },
      ),
    );
  }

  MenuStyle menuBarStyle(BuildContext context) {
    return MenuStyle(
      elevation: WidgetStateProperty.resolveWith<double>(
        (states) => 2,
      ),
      shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
        (states) {
          return const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          );
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (Utils.isDarkMode(context)) {
            return Theme.of(context).colorScheme.surfaceContainerLowest;
          }

          return null;
        },
      ),
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry>(
        (states) {
          return const EdgeInsets.symmetric(horizontal: 12);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: transparent
          ? transparentMenuBarStyle(context)
          : menuBarStyle(context),
      children: barItems,
    );
  }
}
