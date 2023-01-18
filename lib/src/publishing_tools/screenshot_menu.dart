import 'dart:convert';

import 'package:dfc_flutter/src/utils/menu_utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenshotMenuItem {
  ScreenshotMenuItem({this.title = kNoTextTitle, this.filename = 'no-title'});
  String? title;
  String? filename;

  static const kNoTextTitle = 'No Title';

  String? get displayTitle => title == kNoTextTitle ? '' : title;

  static Future<List<ScreenshotMenuItem>> get items async {
    final List<ScreenshotMenuItem> result = [];

    final String data = await rootBundle.loadString('assets/screenshots.json');

    final Map<String, dynamic> jsonMap =
        json.decode(data) as Map<String, dynamic>;

    final dataList = List<Map<dynamic, dynamic>>.from(jsonMap['data'] as List);

    // add no title choice
    result.add(ScreenshotMenuItem());
    for (final x in dataList) {
      result.add(
        ScreenshotMenuItem(
          title: x['title'] as String?,
          filename: x['filename'] as String?,
        ),
      );
    }

    return result;
  }
}

class ScreenshotMenu extends StatefulWidget {
  const ScreenshotMenu({this.onItemSelected, this.selectedItem});

  final void Function(ScreenshotMenuItem)? onItemSelected;
  final ScreenshotMenuItem? selectedItem;

  @override
  _ScreenshotMenuState createState() => _ScreenshotMenuState();
}

class _ScreenshotMenuState extends State<ScreenshotMenu> {
  List<ScreenshotMenuItem> items = [];

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    items = await ScreenshotMenuItem.items;

    if (mounted) {
      setState(() {});
    }
  }

  Widget _menuButton(BuildContext context) {
    final Widget button = SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                widget.selectedItem!.title!,
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

    final List<PopupMenuItem<ScreenshotMenuItem>> menuItems = [];

    for (final item in items) {
      menuItems.add(
        popupMenuItem<ScreenshotMenuItem>(
          value: item,
          child: MenuItemSpec(
            iconData: Icons.compare,
            name: item.title!,
          ),
        ),
      );
    }

    return PopupMenuButton<ScreenshotMenuItem>(
      itemBuilder: (context) {
        return menuItems;
      },
      onSelected: (selected) {
        widget.onItemSelected!(selected);
      },
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _menuButton(context);
  }
}
