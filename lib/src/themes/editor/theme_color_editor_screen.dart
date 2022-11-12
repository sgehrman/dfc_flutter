import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/widgets/headers/browser_header.dart';
import 'package:dfc_flutter/src/widgets/list_row.dart';
import 'package:dfc_flutter/src/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
  _ThemeColorEditorWidgetState createState() => _ThemeColorEditorWidgetState();
}

class _ThemeColorEditorWidgetState extends State<ThemeColorEditorWidget> {
  late HSVColor currentColor;
  late ThemeSet themeSet;

  @override
  void initState() {
    super.initState();

    themeSet = widget.themeSet;

    // color picker crashes if you send nil.  An invalid themeset might have null colors from bad scan etc.
    final Color color = themeSet.colorForField(widget.field) ?? Colors.black;
    currentColor = HSVColor.fromColor(color);
  }

  void changeColorHsv(HSVColor hsvColor) {
    setState(() {
      currentColor = hsvColor;

      final Color color = hsvColor.toColor();
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
              labelTypes: const [],
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(8)),
              enableAlpha: false,
              pickerColor: currentColor.toColor(),
              pickerHsvColor: currentColor,
              onHsvColorChanged: changeColorHsv,
              onColorChanged: (color) {
                // using the hsv color above? test this.
              },
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
                changeColorHsv(HSVColor.fromColor(themeSet.primaryColor));
              },
            ),
          ],
        ),
      ),
    );
  }
}
