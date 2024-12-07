import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/themes/theme_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/tool_tip.dart';
import 'package:flutter/material.dart';

class MenuButtonBarUtils {
  static Widget _dividerWidget(BuildContext context) {
    return const Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Divider(
          height: 1,
        ),
      ),
    );
  }

  static ButtonStyle _menuiItemStyle(
    BuildContext context, {
    bool selected = false,
  }) {
    return ButtonStyle(
      animationDuration: Duration.zero,
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry?>(
        (states) {
          return const EdgeInsets.symmetric(horizontal: 40);
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          // if (ThemeUtils.isHovered(states)) {
          //   return context.primary;
          // }

          // this gets rid of the faint background left when popping open
          // a submenu and moving mouse ourside of the menu.
          if (ThemeUtils.isFocused(states)) {
            // lowest seems to be the default menu background color
            return context.surfaceContainerLowest;
          }

          if (selected) {
            return Theme.of(context).highlightColor;
          }

          return null;
        },
      ),
      // foregroundColor: WidgetStateProperty.resolveWith<Color?>(
      //   (states) {
      //     return _textIconColor(context, states);
      //   },
      // ),
      // iconColor: WidgetStateProperty.resolveWith<Color?>(
      //   (states) {
      //     return _textIconColor(context, states);
      //   },
      // ),
    );
  }

  // helper, convert List<MenubarItemData> to List<Widget>
  static List<Widget> buildMenuItems({
    required BuildContext context,
    required List<MenuButtonBarItemData> menuData,
  }) {
    final List<Widget> menuItems = [];

    for (final itemData in menuData) {
      Widget? child;

      if (Utils.isNotEmpty(itemData.title)) {
        // icon a little close to the text, adding some padding
        child = Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(itemData.title!),
        );
      }

      // add tooltip
      if (child != null && itemData.tooltip.isNotEmpty) {
        child = ToolTip(
          message: itemData.tooltip,
          child: child,
        );
      }

      if (itemData.divider) {
        menuItems.add(_dividerWidget(context));
      } else if (itemData.children.isNotEmpty) {
        final children = buildMenuItems(
          context: context,
          menuData: itemData.children,
        );

        menuItems.add(
          SubmenuButton(
            menuChildren: [
              ...children,
            ],
            leadingIcon: itemData.leading,
            style: _menuiItemStyle(context),
            // child can't be null, interface is bad
            child: child ?? const Text(''),
          ),
        );
      } else {
        menuItems.add(
          MenuItemButton(
            onPressed: itemData.enabled ? itemData.action : null,
            trailingIcon: itemData.trailing,
            leadingIcon: itemData.leading,
            style: _menuiItemStyle(context, selected: itemData.selected),
            // child can't be null, interface is bad
            child: child ?? const Text(''),
          ),
        );
      }
    }

    return menuItems;
  }
}
