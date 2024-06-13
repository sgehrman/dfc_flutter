import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item_widget.dart';
import 'package:flutter/material.dart';

class MenuButtonItem<T> {
  MenuButtonItem({
    required this.title,
    required this.value,
    this.iconData,
    this.iconWidget,
    this.tooltip,
  });
  final String title;
  final T value;
  final IconData? iconData;
  final Widget? iconWidget;
  final String? tooltip;
}

class MenuButton<T> extends StatelessWidget {
  const MenuButton({
    required this.items,
    required this.onItemSelected,
    required this.selectedItem,
    this.fontSize = 16,
    this.arrowSize = 32,
    this.iconOnly = false,
  });

  final void Function(MenuButtonItem<T>) onItemSelected;
  final MenuButtonItem<T> selectedItem;
  final List<MenuButtonItem<T>> items;
  final double fontSize;
  final double arrowSize;
  final bool iconOnly;

  Widget _button(BuildContext context) {
    if (iconOnly) {
      return Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Icon(
            Icons.arrow_drop_down,
            size: arrowSize,
            color: Colors.white,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(
              selectedItem.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.arrow_drop_down,
              size: arrowSize,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<MenuButtonItem<T>>> menuItems = [];

    for (final item in items) {
      if (Utils.isEmpty(item.title)) {
        menuItems.add(
          popupMenuItem<MenuButtonItem<T>>(
            value: item,
            child: const Divider(),
            enabled: false,
          ),
        );
      } else {
        menuItems.add(
          popupMenuItem<MenuButtonItem<T>>(
            value: item,
            child: MenuItemWidget(
              iconData: item.iconData,
              iconWidget: item.iconWidget,
              name: item.title,
              tooltip: item.tooltip,
            ),
          ),
        );
      }
    }

    return PopupMenuButton<MenuButtonItem<T>>(
      initialValue: selectedItem,
      constraints: const BoxConstraints(
        minWidth: 2.0 * 56.0,
        maxWidth: 15.0 * 56.0,
      ),
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        onItemSelected(selected);
      },
      child: _button(context),
    );
  }
}
