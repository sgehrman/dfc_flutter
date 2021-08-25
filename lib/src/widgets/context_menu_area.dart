import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';
import 'package:flutter/material.dart';

class MenuItemData {
  MenuItemData({
    required this.title,
    this.icon,
    this.action,
    this.level = 0,
    this.enabled = true,
  });

  factory MenuItemData.divider() {
    return MenuItemData._divider();
  }

  MenuItemData._divider()
      : title = '',
        icon = null,
        enabled = false,
        level = 0,
        action = null;

  final String title;
  final Icon? icon;
  final bool enabled;
  final int level;
  final void Function()? action;
}

// =================================================================
// =================================================================

Future<void> showContextMenu(
  Offset localPosition,
  BuildContext context,
  List<MenuItemData> menuData,
) async {
  final List<PopupMenuEntry<MenuItemData>> menuItems = [];

  for (final itemData in menuData) {
    if (Utils.isEmpty(itemData.title)) {
      menuItems.add(const PopupMenuDivider(height: 2));
    } else {
      menuItems.add(
        PopupMenuItem<MenuItemData>(
          value: itemData,
          enabled: itemData.enabled,
          child: MenuItem(
            icon: itemData.icon,
            name: itemData.title,
            level: itemData.level,
          ),
        ),
      );
    }
  }

  final result = await MenuUtils.displayMenu<MenuItemData>(
    context: context,
    localPosition: localPosition,
    menuItems: menuItems,
  );

  if (result != null) {
    result.action?.call();
  }
}

// =================================================================
// =================================================================

class ContextMenuArea extends StatelessWidget {
  const ContextMenuArea({
    required this.child,
    required this.buildMenu,
  });

  final Widget child;
  final List<MenuItemData> Function() buildMenu;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // we never want the secondary key to start a drag
      // so we implement these to keep it from getting to the drag widget if any
      onSecondaryLongPress: () {},
      onSecondaryLongPressDown: (details) {},
      onSecondaryLongPressStart: (details) {},
      onSecondaryTapDown: (details) {
        showContextMenu(
          details.localPosition,
          context,
          buildMenu(),
        );
      },
      onLongPressStart: (details) {
        showContextMenu(
          details.localPosition,
          context,
          buildMenu(),
        );
      },
      child: child,
    );
  }
}
