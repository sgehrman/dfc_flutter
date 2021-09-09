import 'dart:async';
import 'dart:ui' as ui;

import 'package:dfc_flutter/src/dialogs/string_dialog.dart';
import 'package:dfc_flutter/src/publishing_tools/phone_menu.dart';
import 'package:dfc_flutter/src/publishing_tools/screenshot_maker.dart';
import 'package:dfc_flutter/src/publishing_tools/screenshot_menu.dart';
import 'package:dfc_flutter/src/publishing_tools/size_menu.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/colored_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScreenshotsScreen extends StatefulWidget {
  const ScreenshotsScreen({
    required this.imagePath,
  });

  final String imagePath;

  @override
  _ScreenshotsScreenState createState() => _ScreenshotsScreenState();
}

class _ScreenshotsScreenState extends State<ScreenshotsScreen> {
  ScreenshotMaker maker = ScreenshotMaker();
  Future<CaptureResult>? _image;
  PhoneMenuItem selectedItem = PhoneMenuItem.items[1];
  bool? _showBackground = true;
  String? _title;
  SizeMenuItem sizeMenuItem =
      SizeMenuItem(title: 'Image Size', type: SizeType.imageSize);

  ScreenshotMenuItem selectedScreenshotItem = ScreenshotMenuItem();

  late ui.Image uiImage;

  @override
  void initState() {
    super.initState();

    Utils.loadImageFromPath(widget.imagePath).then((ui.Image image) {
      uiImage = image;
      setState(() {});

      refreshPreview();
    });
  }

  Future<void> refreshPreview() async {
    // delay since we could modify a state var that won't be synced until next refresh
    await Future.delayed(Duration.zero, () {});

    setState(() {
      _image = maker.createImage(
        uiImage,
        _title ?? selectedScreenshotItem.displayTitle,
        selectedItem.type,
        showBackground: _showBackground!,
        resultImageSize: sizeMenuItem.type,
      );
    });
  }

  Future<void> _saveClicked() async {
    // ask user for file name
    final String? fileName = await showStringDialog(
      context: context,
      title: 'Filename',
      message: 'Choose a file name',
      defaultName: selectedScreenshotItem.filename!,
    );

    if (Utils.isNotEmpty(fileName)) {
      try {
        final ui.Image assetImage =
            await Utils.loadImageFromPath(widget.imagePath);

        final CaptureResult capture = await maker.createImage(
          assetImage,
          _title ?? selectedScreenshotItem.displayTitle,
          selectedItem.type,
          showBackground: _showBackground!,
          resultImageSize: sizeMenuItem.type,
        );

        await maker.saveToFile(fileName, capture);
      } catch (e) {
        print(e);
      }

      Utils.showSnackbar(
        context,
        'Generate Complete',
      );
    }
  }

  Widget _topToolbar() {
    return Row(
      children: [
        PhoneMenu(
          onItemSelected: (PhoneMenuItem item) {
            setState(() {
              selectedItem = item;
            });

            refreshPreview();
          },
          selectedItem: selectedItem,
        ),
        ScreenshotMenu(
          onItemSelected: (ScreenshotMenuItem item) {
            setState(() {
              selectedScreenshotItem = item;
            });

            refreshPreview();
          },
          selectedItem: selectedScreenshotItem,
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await showStringDialog(
              context: context,
              keyboardType: TextInputType.multiline,
              title: 'Enter Title',
              message: 'You can hit return to add lines',
              minLines: 2,
              maxLines: 6,
            );

            if (result != null) {
              _title = result;

              setState(() {});

              await refreshPreview();
            }
          },
          child: const Text('Title'),
        ),
        SizeMenu(
          onItemSelected: (SizeMenuItem item) {
            setState(() {
              sizeMenuItem = item;
            });

            refreshPreview();
          },
          selectedItem: sizeMenuItem,
        ),
      ],
    );
  }

  Widget _saveBar() {
    return Row(
      children: <Widget>[
        Flexible(
          child: CheckboxListTile(
            value: _showBackground,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Show Background'),
            onChanged: (x) {
              setState(() {
                _showBackground = x;
              });

              refreshPreview();
            },
          ),
        ),
        const SizedBox(width: 12),
        ColoredButton(
          onPressed: _saveClicked,
          title: 'Save',
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  List<Widget> _imagePreview(AsyncSnapshot<CaptureResult> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const [
        Center(
          child: CircularProgressIndicator(),
        )
      ];
    }

    if (snapshot.hasData) {
      return [
        Text(
          '${snapshot.data!.width} x ${snapshot.data!.height}',
          textAlign: TextAlign.center,
        ),
        Container(
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2.0),
          ),
          child: Image.memory(
            snapshot.data!.data,
            // scale: MediaQuery.of(context).devicePixelRatio,
          ),
        ),
      ];
    }

    return [NothingWidget()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screenshot capture'),
      ),
      body: FutureBuilder<CaptureResult>(
        future: _image,
        builder: (BuildContext context, AsyncSnapshot<CaptureResult> snapshot) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  _topToolbar(),
                  const SizedBox(height: 10),
                  _saveBar(),
                  ..._imagePreview(snapshot),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
