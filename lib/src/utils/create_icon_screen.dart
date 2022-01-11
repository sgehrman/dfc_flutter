import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dfc_flutter/src/file_system/file_system.dart';
import 'package:dfc_flutter/src/widgets/colored_button.dart';
import 'package:flutter/material.dart';

class CreateIconScreen extends StatefulWidget {
  @override
  _CreateIconScreenState createState() => _CreateIconScreenState();
}

class _CreateIconScreenState extends State<CreateIconScreen> {
  late String? iconPath;
  Uint8List? iconData;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    iconPath = await FileSystem.documentsPath;
    iconPath = '$iconPath/icon.png';

    iconData = File(iconPath!).readAsBytesSync();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Creator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 64,
                height: 64,
                child: Icon(
                  Icons.person_add,
                  size: 64,
                ),
                // child: SvgPicture.asset(
                //   'assets/images/tools.svg',
                //   placeholderBuilder: (BuildContext context) =>
                //       const Center(child: CircularProgressIndicator()),
                // ),
              ),
              if (iconData != null) Image.memory(iconData!),
              ColoredButton(
                onPressed: () async {
                  await saveImage();

                  iconData = await File(iconPath!).readAsBytes();
                  setState(() {});
                },
                title: 'Save Icon',
              ),
              const SizedBox(height: 20),
              const Text(r'$ adb root'),
              const Text(r'$ adb shell'),
              const Text(
                r'$ adb pull /sdcard/Android/data/re.distantfutu.journal/files/icon.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextPainter _iconPainter(Color color, double size) {
    const icon = Icons.person_add;
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: color,
        fontSize: size,
        fontFamily: icon.fontFamily,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );
    textPainter.layout();

    return textPainter;
  }

  Future<void> saveImage() async {
    final File file = File(iconPath!);
    file.createSync(recursive: true);

    // final String svgString =
    //     await rootBundle.loadString('assets/images/tools.svg');

    // final DrawableRoot root = await svg.fromSvgString(svgString, 'svg');
    // final ui.Picture picture = root.toPicture(
    //   size: iconRect.size,
    //   colorFilter: const ColorFilter.mode(Colors.cyan, BlendMode.srcATop),
    // );

    // final ui.Image iconImage =
    //     await picture.toImage(iconRect.width.toInt(), iconRect.height.toInt());

    // draw in canvas
    const kWidth = 1024;
    final Rect rect = Offset.zero & Size(kWidth.toDouble(), kWidth.toDouble());
    const double kIconSize = kWidth * .90;
    const Color iconColor = Colors.white;
    final Rect iconRect = Offset.zero & const Size(kIconSize, kIconSize);

    // const color = Color.fromRGBO(12, 43, 64, 1);

    // final Paint paint = Paint();
    // paint.shader = LinearGradient(
    //         colors: [color, Utils.darken(color)],
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight)
    //     .createShader(rect);

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // canvas.drawRect(rect, paint);

    final Rect imageRect = Rect.fromCenter(
      center: rect.center,
      width: iconRect.width,
      height: iconRect.height,
    );
    // canvas.drawImage(iconImage, imageRect.topLeft, paint);

    TextPainter textPainter = _iconPainter(
      Colors.black54,
      kIconSize,
    );
    textPainter.paint(canvas, imageRect.topLeft.translate(-1, -4));

    textPainter = _iconPainter(
      iconColor,
      kIconSize,
    );
    textPainter.paint(canvas, imageRect.topLeft.translate(0, 0));

    final ui.Picture pict = recorder.endRecording();

    final ui.Image resultImage = await pict.toImage(kWidth, kWidth);

    final ByteData data =
        (await resultImage.toByteData(format: ui.ImageByteFormat.png))!;

    final buffer = data.buffer;

    await file.writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }
}
