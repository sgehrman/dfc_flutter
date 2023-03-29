import 'dart:convert';

// import 'package:barcode_image/barcode_image.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dfc_flutter/src/dialogs/widget_dialog.dart';
import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/google_fonts/google_fonts_screen.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/themes/editor/theme_color_editor_screen.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_button.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/list_row.dart';
import 'package:dfc_flutter/src/widgets/shrink_wrapped_list.dart';
import 'package:dfc_flutter/src/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ThemeEditorWidget extends StatefulWidget {
  @override
  State<ThemeEditorWidget> createState() => _ThemeEditorWidgetState();
}

class _ThemeEditorWidgetState extends State<ThemeEditorWidget> {
  void _showQRCodeDialog(BuildContext context) {
    final String jsonStr = json.encode(ThemeSetManager().currentTheme!.toMap());

    // here on purpose so we can easily grab the json if we want
    print(jsonStr);

    final List<Widget> children = [
      BarcodeWidget(
        height: 300,
        width: 300,
        backgroundColor: Colors.white,
        barcode: Barcode.qrCode(),
        padding: const EdgeInsets.all(10),
        data: jsonStr,
      ),
      // IconButton(
      //   icon: const Icon(Icons.share),
      //   onPressed: () async {
      //     final image = img.Image(320, 320);
      //     img.fill(image, img.getColor(255, 255, 255));

      //     drawBarcode(
      //       image,
      //       Barcode.qrCode(),
      //       jsonStr,
      //       width: 300,
      //       height: 300,
      //       x: 10,
      //       y: 10,
      //     );

      //     final Directory directory = await getTemporaryDirectory();

      //     final String path = p.join(directory.path, 'shareTheme.png');

      //     File(path).writeAsBytesSync(img.encodePng(image));

      //     await ShareExtend.share(path, 'image');
      //   },
      // ),
    ];

    showWidgetDialog(
      context: context,
      title: 'Scan the QRcode import the current theme.',
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fontName = ThemeSetManager()
        .googleFont
        .replaceFirst('TextTheme', '')
        .fromCamelCase();

    final ThemeSet? theme = ThemeSetManager().currentTheme;

    const colorFields = ThemeSetColor.values;

    return Column(
      children: [
        ThemeSetButton(
          themeSets: ThemeSetManager.themeSets,
          onItemSelected: (newTheme) {
            ThemeSetManager().currentTheme = newTheme;
          },
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ShrinkWrappedList(
            itemCount: colorFields.length,
            itemBuilder: (context, index) {
              return ListRow(
                title: theme!.nameForField(colorFields[index]),
                leading: Container(
                  height: 40,
                  width: 40,
                  color: theme.colorForField(colorFields[index]),
                ),
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) => ThemeColorEditorScreen(
                        themeSet: theme,
                        field: colorFields[index],
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 4),
          ),
        ),
        const SizedBox(height: 6),
        SwitchListTile(
          value: ThemeSetManager().lightBackground,
          onChanged: (bool newValue) {
            ThemeSetManager().lightBackground = newValue;
          },
          title: const Text('Light Background'),
        ),
        SwitchListTile(
          value: ThemeSetManager().integratedAppBar,
          onChanged: (bool newValue) {
            ThemeSetManager().integratedAppBar = newValue;
          },
          title: const Text('Integrated app bar'),
        ),
        ListTile(
          trailing: ThemeButton(
            title: 'Change Font',
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) {
                    return GoogleFontsScreen();
                  },
                ),
              );
            },
          ),
          title: Text(
            fontName,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // scanning only on mobile
            if (Utils.isMobile)
              ElevatedButton.icon(
                onPressed: () async {
                  final String barcodeScanRes =
                      await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666',
                    'Cancel',
                    true,
                    ScanMode.DEFAULT,
                  );

                  // "-1" gets returned on cancel or back
                  // we only want json back in this case
                  if (Utils.isNotEmpty(barcodeScanRes) &&
                      barcodeScanRes.firstChar == '{') {
                    final ThemeSet newTheme = ThemeSet.fromMap(
                      json.decode(barcodeScanRes) as Map<String, dynamic>,
                    );

                    ThemeSetManager.saveTheme(newTheme, scanned: true);
                  }
                },
                label: const Text('Scan Theme'),
                icon: const SvgIcon(FontAwesomeSvgs.solidQrcode),
              ),
            ThemeButton(
              onPressed: () {
                _showQRCodeDialog(context);
              },
              title: 'Share Theme',
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ],
    );
  }
}

class ThemeColorData {
  const ThemeColorData({
    this.name,
    this.color,
  });

  final String? name;
  final Color? color;
}
