import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/dialogs/string_dialog.dart';
import 'package:dfc_flutter/src/themes/editor/theme_editor_screen.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/menu_item.dart';

class ThemeSetButton extends StatelessWidget {
  const ThemeSetButton({
    required this.themeSets,
    required this.onItemSelected,
  });

  final void Function(ThemeSet) onItemSelected;
  final List<ThemeSet> themeSets;

  Widget _popupMenu(BuildContext context) {
    final List<ThemeSet> items = themeSets;

    final menuItems = <PopupMenuItem<ThemeSet>>[];

    for (final item in items) {
      menuItems.add(
        PopupMenuItem<ThemeSet>(
          value: item,
          child: MenuItem(
            icon: const Icon(Icons.add_to_home_screen),
            name: item.name,
          ),
        ),
      );
    }

    return Center(
      child: PopupMenuButton<ThemeSet>(
        tooltip: 'Switch Themes',
        offset: const Offset(0, 30),
        itemBuilder: (context) {
          return menuItems;
        },
        onSelected: (selected) {
          onItemSelected(selected);
        },
        child: _menuButton(context),
      ),
    );
  }

  Widget _menuButton(BuildContext context) {
    final Widget button = Padding(
      padding: const EdgeInsets.only(left: 16, right: 11),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Flexible(
            child: Text(
              'Themes',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.arrow_drop_down,
              ),
            ),
          ),
        ],
      ),
    );

    return button;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeSet? currentTheme = ThemeSetManager().currentTheme;

    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThemeEditorScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    final String? name = await showStringDialog(
                      context: context,
                      title: 'Name Theme',
                      defaultName: currentTheme!.name,
                      message: 'Give the theme a unique name.',
                    );

                    if (Utils.isNotEmpty(name)) {
                      ThemeSetManager.saveTheme(
                        currentTheme.copyWith(name: name),
                      );
                    }
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: _popupMenu(context),
        ),
      ],
    );
  }
}
