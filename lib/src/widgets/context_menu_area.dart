import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item_widget.dart';
import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:flutter/material.dart';

class MenuItemData {
  MenuItemData({
    required this.title,
    this.iconData,
    this.iconWidget,
    this.action,
    this.level = 0,
    this.enabled = true,
    this.tooltip,
  });
  MenuItemData._divider()
      : title = '',
        iconData = null,
        iconWidget = null,
        tooltip = null,
        enabled = false,
        level = 0,
        action = null;

  factory MenuItemData.divider() {
    return MenuItemData._divider();
  }

  // helper, convert List<MenuItemData> to List<PopupMenuEntry>
  static List<PopupMenuEntry<MenuItemData>> popupEntries(
    List<MenuItemData> menuData,
  ) {
    final List<PopupMenuEntry<MenuItemData>> menuItems = [];

    for (final itemData in menuData) {
      if (Utils.isEmpty(itemData.title)) {
        menuItems.add(const PopupMenuDivider());
      } else {
        menuItems.add(
          popupMenuItem<MenuItemData>(
            value: itemData,
            enabled: itemData.enabled,
            child: MenuItemWidget(
              iconData: itemData.iconData,
              iconWidget: itemData.iconWidget,
              name: itemData.title,
              level: itemData.level,
              tooltip: itemData.tooltip,
            ),
          ),
        );
      }
    }

    return menuItems;
  }

  final String title;
  final IconData? iconData;
  final Widget? iconWidget;
  final bool enabled;
  final int level;
  final String? tooltip;
  final void Function()? action;
}

// =================================================================
// =================================================================

Future<void> showContextMenu({
  required BuildContext context,
  required Offset localPosition,
  required List<MenuItemData> menuData,
}) async {
  final List<PopupMenuEntry<MenuItemData>> menuItems =
      MenuItemData.popupEntries(menuData);

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
          localPosition: details.localPosition,
          context: context,
          menuData: buildMenu(),
        );
      },
      // onLongPressStart: (details) {
      //   showContextMenu(
      //     details.localPosition,
      //     context,
      //     buildMenu(),
      //   );
      // },
      child: child,
    );
  }
}

// =================================================================

class MenuPopupButton extends StatelessWidget {
  const MenuPopupButton({
    required this.child,
    required this.buildMenu,
    this.radius = Material.defaultSplashRadius,
    this.tooltip = '',
  });

  final Widget child;
  final List<MenuItemData> Function() buildMenu;
  final double radius;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return ToolTip(
      message: tooltip,
      child: InkResponse(
        radius: radius,
        onTap: () {
          showContextMenu(
            localPosition: Offset(0, context.size?.height ?? 0),
            context: context,
            menuData: buildMenu(),
          );
        },
        child: child,
      ),
    );
  }
}
