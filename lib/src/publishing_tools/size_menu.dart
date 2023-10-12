import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item_widget.dart';
import 'package:flutter/material.dart';

enum SizeType {
  imageSize,
  ios_1284_2778,
  ios_1242_2208,
  ios_2048_2732,
}

class SizeMenuItem {
  SizeMenuItem({required this.title, required this.type});
  String title;
  SizeType type;

  static List<SizeMenuItem> items = <SizeMenuItem>[
    SizeMenuItem(title: 'Image Size', type: SizeType.imageSize),
    SizeMenuItem(title: '6.5 1284x2778', type: SizeType.ios_1284_2778),
    SizeMenuItem(title: '5.5 1242x2208', type: SizeType.ios_1242_2208),
    SizeMenuItem(title: '12.9 2048x2732', type: SizeType.ios_2048_2732),
  ];
}

class SizeMenu extends StatelessWidget {
  const SizeMenu({this.onItemSelected, this.selectedItem});

  final void Function(SizeMenuItem)? onItemSelected;
  final SizeMenuItem? selectedItem;

  Widget _menuButton(BuildContext context) {
    final button = Padding(
      padding: const EdgeInsets.only(left: 16, right: 11),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Text(
              selectedItem!.title,
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

    final List<PopupMenuItem<SizeMenuItem>> menuItems = [];

    for (final item in SizeMenuItem.items) {
      menuItems.add(
        popupMenuItem<SizeMenuItem>(
          value: item,
          child: MenuItemWidget(
            iconData: Icons.compare,
            name: item.title,
          ),
        ),
      );
    }

    return PopupMenuButton<SizeMenuItem>(
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        onItemSelected!(selected);
      },
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _menuButton(context);
  }
}
