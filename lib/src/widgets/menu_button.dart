import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';

class MenuButtonItem {
  MenuButtonItem({
    required this.title,
    required this.value,
  });
  String title;
  dynamic value;
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    required this.items,
    required this.onItemSelected,
    required this.selectedItem,
  });

  final void Function(MenuButtonItem) onItemSelected;
  final MenuButtonItem selectedItem;
  final List<MenuButtonItem> items;

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
            ),
          ),
          const FittedBox(
            fit: BoxFit.fill,
            child: Icon(
              Icons.arrow_drop_down,
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
            icon: const Icon(Icons.compare),
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
