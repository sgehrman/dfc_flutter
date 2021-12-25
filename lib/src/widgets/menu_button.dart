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

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.items,
    required this.onItemSelected,
    required this.selectedItem,
    this.size = 16,
    this.iconSize = 24,
  });

  final void Function(MenuButtonItem) onItemSelected;
  final MenuButtonItem selectedItem;
  final List<MenuButtonItem> items;
  final double size;
  final double iconSize;

  Widget _menuButton(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.only(left: 16, right: 11),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(
              selectedItem.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: size),
            ),
          ),
          FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.arrow_drop_down,
              size: size,
            ),
          ),
        ],
      ),
    );

    final List<PopupMenuItem<MenuButtonItem>> menuItems = [];

    for (final item in items) {
      menuItems.add(
        PopupMenuItem<MenuButtonItem>(
          value: item,
          child: MenuItem(
            icon: Icon(
              item.iconData,
              size: iconSize,
            ),
            name: item.title,
          ),
        ),
      );
    }

    return PopupMenuButton<MenuButtonItem>(
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        onItemSelected(selected);
      },
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _menuButton(context);
  }
}
