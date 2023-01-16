import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';
import 'package:flutter/material.dart';

enum PhoneType {
  onePlus7t,
  iPhone11,
  iPhone5,
  iPad,
  iPadPro,
}

class PhoneMenuItem {
  PhoneMenuItem({this.title, this.type});
  String? title;
  PhoneType? type;

  static List<PhoneMenuItem> items = <PhoneMenuItem>[
    PhoneMenuItem(title: 'One Plus 7t', type: PhoneType.onePlus7t),
    PhoneMenuItem(title: 'iPhone 11', type: PhoneType.iPhone11),
    PhoneMenuItem(title: 'iPhone 5', type: PhoneType.iPhone5),
    PhoneMenuItem(title: 'iPad', type: PhoneType.iPad),
    PhoneMenuItem(title: 'iPad Pro', type: PhoneType.iPadPro),
  ];
}

class PhoneMenu extends StatelessWidget {
  const PhoneMenu({this.onItemSelected, this.selectedItem});

  final void Function(PhoneMenuItem)? onItemSelected;
  final PhoneMenuItem? selectedItem;

  Widget _menuButton(BuildContext context) {
    final Widget button = SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                selectedItem!.title!,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final List<PopupMenuItem<PhoneMenuItem>> menuItems = [];

    for (final item in PhoneMenuItem.items) {
      menuItems.add(
        popupMenuItem<PhoneMenuItem>(
          value: item,
          child: MenuItemSpec(
            icon: const Icon(Icons.compare),
            name: item.title!,
          ),
        ),
      );
    }

    return PopupMenuButton<PhoneMenuItem>(
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
