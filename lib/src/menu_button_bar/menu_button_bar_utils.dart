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

  static Color _textIconColor({
    required BuildContext context,
    required Set<WidgetState> states,
    required bool selected,
  }) {
    if (ThemeUtils.isDisabled(states)) {
      return context.dimTextColor;
    }

    if (ThemeUtils.isHovered(states)) {
      return context.onPrimary;
    }

    return context.lightTextColor;
  }

  static ButtonStyle _menuiItemStyle(
    BuildContext context, {
    bool selected = false,
  }) {
    return ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: Duration.zero,
      padding: WidgetStateProperty.resolveWith<EdgeInsetsGeometry?>(
        (states) {
          // give room for scrollbar on right
          return const EdgeInsets.only(left: 20, right: 20);
        },
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (ThemeUtils.isHovered(states)) {
            return context.primary;
          }

          if (selected) {
            return context.lightPrimary();
            // return Theme.of(context).highlightColor;
          }

          return null;
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          return _textIconColor(
            context: context,
            states: states,
            selected: selected,
          );
        },
      ),
      iconColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          return _textIconColor(
            context: context,
            states: states,
            selected: selected,
          );
        },
      ),
    );
  }

  // helper, convert List<MenubarItemData> to List<Widget>
  static List<Widget> buildMenuItems({
    required BuildContext context,
    required List<MenuButtonBarItemData> menuData,
  }) {
    final List<Widget> menuItems = [];

    final style = _menuiItemStyle(context);
    final selectedStyle = _menuiItemStyle(context, selected: true);

    for (final itemData in menuData) {
      Widget? child;

      if (Utils.isNotEmpty(itemData.title)) {
        // icon a little close to the text, adding some padding
        child = Padding(
          padding: const EdgeInsets.only(left: 8),
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

      Widget? leading = itemData.leading;

      if (itemData.level > 0) {
        final leadingSpace = SizedBox(width: 20.0 * itemData.level);

        if (leading != null) {
          leading = Row(
            mainAxisSize: MainAxisSize.min,
            children: [leadingSpace, leading],
          );
        } else {
          leading = leadingSpace;
        }
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
            leadingIcon: leading,
            style: style,
            // child can't be null, interface is bad
            child: child ?? const Text(''),
          ),
        );
      } else {
        menuItems.add(
          MenuItemButton(
            onPressed: itemData.enabled ? itemData.action : null,
            trailingIcon: itemData.trailing,
            leadingIcon: leading,
            style: itemData.selected ? selectedStyle : style,
            // child can't be null, interface is bad
            child: child ?? const Text(''),
          ),
        );
      }
    }

    return menuItems;
  }
}
