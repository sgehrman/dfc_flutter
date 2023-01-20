import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';
import 'package:flutter/material.dart';

class MenuButtonItem<T> {
  MenuButtonItem({
    required this.title,
    required this.value,
    required this.iconData,
  });
  final String title;
  final T value;
  final IconData iconData;
}

class MenuButton<T> extends StatelessWidget {
  const MenuButton({
    required this.items,
    required this.onItemSelected,
    required this.selectedItem,
    this.fontSize = 16,
    this.arrowSize = 32,
  });

  final void Function(MenuButtonItem<T>) onItemSelected;
  final MenuButtonItem<T> selectedItem;
  final List<MenuButtonItem<T>> items;
  final double fontSize;
  final double arrowSize;

  @override
  Widget build(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(
              selectedItem.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
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

    final List<PopupMenuItem<MenuButtonItem<T>>> menuItems = [];

    for (final item in items) {
      menuItems.add(
        popupMenuItem<MenuButtonItem<T>>(
          value: item,
          child: MenuItemSpec(
            iconData: item.iconData,
            name: item.title,
          ),
        ),
      );
    }

    return PopupMenuButton<MenuButtonItem<T>>(
      initialValue: selectedItem,
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        onItemSelected(selected);
      },
      child: button,
    );
  }
}
