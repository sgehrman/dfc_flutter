import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/widgets/headers/browser_header.dart';
import 'package:dfc_flutter/src/widgets/list_row.dart';
import 'package:dfc_flutter/src/widgets/theme_button.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ThemeColorEditorScreen extends StatelessWidget {
  const ThemeColorEditorScreen({
    required this.themeSet,
    required this.field,
  });

  final ThemeSet themeSet;
  final ThemeSetColor field;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(themeSet.nameForField(field))),
      body: ThemeColorEditorWidget(
        themeSet: themeSet,
        field: field,
      ),
    );
  }
}

// ===============================================================

class ThemeColorEditorWidget extends StatefulWidget {
  const ThemeColorEditorWidget({
    required this.themeSet,
    required this.field,
  });

  final ThemeSet themeSet;
  final ThemeSetColor field;

  @override
  State<ThemeColorEditorWidget> createState() => _ThemeColorEditorWidgetState();
}

class _ThemeColorEditorWidgetState extends State<ThemeColorEditorWidget> {
  late Color currentColor;
  late ThemeSet themeSet;

  @override
  void initState() {
    super.initState();

    themeSet = widget.themeSet;

    currentColor = themeSet.colorForField(widget.field) ?? Colors.black;
  }

  void changeColorHsv(Color color) {
    setState(() {
      currentColor = color;

      themeSet = themeSet.copyWithColor(widget.field, color);

      ThemeSetManager().currentTheme = themeSet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            ColorPicker(
              color: currentColor,
              showColorCode: true,
              padding: EdgeInsets.zero,
              showRecentColors: true,
              showColorName: true,
              showMaterialName: true,
              pickersEnabled: const {
                ColorPickerType.both: true,
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: false,
                ColorPickerType.customSecondary: false,
                ColorPickerType.wheel: true,
              },
              onColorChanged: changeColorHsv,
            ),
            const SizedBox(height: 20),
            const BrowserHeader(
              'Example Header',
            ),
            const ListRow(
              padding: EdgeInsets.symmetric(horizontal: 16),
              title: 'Example List item',
              leading: SvgIcon(FontAwesomeSvgs.regularFolder),
              subtitle: 'Subtitle example',
            ),
            const ListRow(
              padding: EdgeInsets.symmetric(horizontal: 16),
              title: 'Example List item',
              leading: SvgIcon(FontAwesomeSvgs.regularFolder),
              subtitle: 'Subtitle example',
            ),
            const SizedBox(height: 10),
            ThemeButton(
              title: 'Sample Button',
              onPressed: () {
                changeColorHsv(themeSet.primaryColor);
              },
            ),
          ],
        ),
      ),
    );
  }
}
