import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dfc_flutter/src/file_system/file_system.dart';
import 'package:dfc_flutter/src/publishing_tools/phone_menu.dart';
import 'package:dfc_flutter/src/publishing_tools/phone_shapes.dart';
import 'package:dfc_flutter/src/publishing_tools/screenshot_params.dart';
import 'package:dfc_flutter/src/publishing_tools/size_menu.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

class CaptureResult {
  const CaptureResult(this.data, this.width, this.height);

  final Uint8List data;
  final int width;
  final int height;
}

class ScreenshotMaker {
  Future<CaptureResult> createImage(
    ui.Image assetImage,
    String? title,
    PhoneType? type, {
    bool showBackground = true,
    SizeType? resultImageSize,
  }) {
    final imageSize = Size(
      assetImage.width.toDouble(),
      assetImage.height.toDouble(),
    );

    final p = phoneParams(
      imageSize: imageSize,
      type: type,
      showBackground: showBackground,
    );

    // create canvas to draw on
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    drawPhoneOnCanvas(
      canvas: canvas,
      p: p,
      title: title,
      assetImage: assetImage,
    );

    PhoneShapes.drawPhoneNotch(
      type: p.type,
      canvas: canvas,
      params: p,
      centerX: p.resultRect.width / 2,
    );

    return _pictureToResults(
      pictureRecorder: pictureRecorder,
      imageSize: imageSize,
      resultImageSize: resultImageSize,
      rect: p.resultRect,
      drawBackground: showBackground,
    );
  }

  void drawPhoneOnCanvas({
    required Canvas canvas,
    required ScreenshotParams p,
    required String? title,
    required ui.Image assetImage,
  }) {
    if (p.showBackground && Utils.isNotEmpty(title)) {
      _drawTitle(
        title: title,
        canvas: canvas,
        centerX: p.resultRect.topCenter.dx,
        startY: p.resultRect.top,
        titleBoxHeight: p.titleBoxHeight,
      );
    }

    // draw frame
    final path = Path();
    final rrect = RRect.fromRectAndRadius(p.phoneRect, p.frameRadius);
    path.addRRect(rrect);

    final fillPaint = Paint();
    fillPaint.color = p.phoneColor;
    canvas.drawPath(path, fillPaint);

    PhoneShapes.drawPhoneButtons(canvas, p);

    // phone frame on top of phone buttons
    final framePaint = Paint();
    framePaint.style = PaintingStyle.stroke;
    framePaint.strokeWidth = 3;
    framePaint.color = p.phoneFrameColor;
    canvas.drawPath(path, framePaint);

    // draw image
    final clipPath = Path();
    final clipRrect =
        RRect.fromRectAndRadius(p.screenshotRect, p.imageFrameRadius);
    clipPath.addRRect(clipRrect);

    canvas.save();
    canvas.clipPath(clipPath);

    paintImage(
      canvas: canvas,
      rect: p.screenshotRect,
      image: assetImage,
      fit: BoxFit.contain,
    );

    canvas.restore();
  }

  Future<CaptureResult> _pictureToResults({
    required ui.PictureRecorder pictureRecorder,
    required Rect rect,
    Size? imageSize,
    SizeType? resultImageSize,
    bool drawBackground = false,
  }) async {
    final pic = pictureRecorder.endRecording();
    final image = await pic.toImage(rect.width.toInt(), rect.height.toInt());

    final resizedImage = await _resizeImage(
      image,
      imageSize,
      drawBackground: drawBackground,
      resultImageSize: resultImageSize,
    );

    final data = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    final buffer = data?.buffer.asUint8List();

    // NSHACK buffer!
    return CaptureResult(buffer!, resizedImage.width, resizedImage.height);
  }

  void _drawBackground({
    required Canvas canvas,
    required Rect rect,
    required Color startColor,
    required Color endColor,
  }) {
    final backPaint = Paint();
    backPaint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
      colors: <Color>[
        startColor,
        endColor,
      ],
    ).createShader(rect);

    canvas.drawRect(rect, backPaint);
  }

  void _drawTitle({
    required Canvas canvas,
    required String? title,
    required double centerX,
    required double startY,
    required double titleBoxHeight,
  }) {
    final span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 84,
        fontWeight: Font.bold,
      ),
      text: title,
    );
    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final w = tp.size.width / 2;
    var h = tp.size.height;
    h = (titleBoxHeight - h) / 2;

    tp.paint(canvas, Offset(centerX - w, startY + h));
  }

  Future<ui.Image> _resizeImage(
    ui.Image image,
    Size? size, {
    bool drawBackground = true,
    SizeType? resultImageSize,
  }) {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    var newSize = size;

    if (resultImageSize != null) {
      switch (resultImageSize) {
        case SizeType.ios_1242_2208:
          newSize = const Size(1242, 2208);
          break;
        case SizeType.ios_1284_2778:
          newSize = const Size(1284, 2778);
          break;
        case SizeType.ios_2048_2732:
          newSize = const Size(2048, 2732);
          break;
        case SizeType.imageSize:
          {
            // enforce 2:1 Google play max aspect ratio
            final aspectRatio = size!.width / size.height;
            if (aspectRatio < 0.5) {
              newSize = Size(size.height / 2, size.height);
            }
          }
          break;
      }
    }

    final rect = Offset.zero & newSize!;

    if (drawBackground) {
      _drawBackground(
        canvas: canvas,
        rect: rect,
        startColor: Colors.pink,
        endColor: Colors.cyan,
      );
    }

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.contain,
    );

    final pic = pictureRecorder.endRecording();

    return pic.toImage(newSize.width.toInt(), newSize.height.toInt());
  }

  Future<void> saveToFile(String? filename, CaptureResult capture) async {
    var path = await FileSystem.documentsPath;
    path = '$path/${filename}_screenshot.png';

    print('saved to: $path');

    final file = File(path);
    file.createSync(recursive: true);

    file.writeAsBytesSync(capture.data);
  }

  static ScreenshotParams phoneParams({
    required PhoneType? type,
    required Size imageSize,
    required bool showBackground,
    Color phoneColor = Colors.black,
    Color phoneFrameColor = Colors.black,
  }) {
    final imageAspectRatio = imageSize.width / imageSize.height;

    double titleBoxHeight = 20;
    double footerBoxHeight = 20;

    if (showBackground) {
      titleBoxHeight = 300;
      footerBoxHeight = 150;
    }

    double phoneFrameWidth;
    Radius frameRadius;
    Radius imageFrameRadius;
    double topBezelHeight = 0;
    double bottomBezelHeight = 0;

    switch (type) {
      case PhoneType.iPad:
      case PhoneType.iPhone5:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(2);
        break;
      case PhoneType.iPadPro:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(40);
        break;
      case PhoneType.iPhone11:
        frameRadius = const Radius.circular(122);
        imageFrameRadius = const Radius.circular(85);
        break;
      case PhoneType.onePlus7t:
      default:
        frameRadius = const Radius.circular(52);
        imageFrameRadius = const Radius.circular(52);
        break;
    }

    switch (type) {
      case PhoneType.iPadPro:
        phoneFrameWidth = 68;
        break;
      case PhoneType.iPad:
      case PhoneType.iPhone5:
        phoneFrameWidth = 48;
        topBezelHeight = 165;
        bottomBezelHeight = topBezelHeight;
        break;
      case PhoneType.iPhone11:
        phoneFrameWidth = 48;
        break;
      case PhoneType.onePlus7t:
      default:
        phoneFrameWidth = 14;
        break;
    }

    final finalHeight = imageSize.height +
        titleBoxHeight +
        footerBoxHeight +
        (phoneFrameWidth * 2) +
        topBezelHeight +
        bottomBezelHeight;
    final resultRect =
        Offset.zero & Size(finalHeight * imageAspectRatio, finalHeight);

    // rect below top border
    var phoneRect = Rect.fromLTWH(
      resultRect.left,
      resultRect.top + titleBoxHeight,
      resultRect.width,
      resultRect.height - (titleBoxHeight + footerBoxHeight),
    );

    phoneRect = Rect.fromCenter(
      center: phoneRect.center,
      width: imageSize.width + (phoneFrameWidth * 2),
      height: imageSize.height +
          (phoneFrameWidth * 2) +
          topBezelHeight +
          bottomBezelHeight,
    );

    // rect for the screenshot
    var screenshotRect = phoneRect.deflate(phoneFrameWidth);
    screenshotRect = Rect.fromLTWH(
      screenshotRect.left,
      screenshotRect.top + topBezelHeight,
      screenshotRect.width,
      screenshotRect.height - (topBezelHeight + bottomBezelHeight),
    );

    return ScreenshotParams(
      imageAspectRatio: imageAspectRatio,
      titleBoxHeight: titleBoxHeight,
      footerBoxHeight: footerBoxHeight,
      phoneFrameWidth: phoneFrameWidth,
      frameRadius: frameRadius,
      imageFrameRadius: imageFrameRadius,
      topBezelHeight: topBezelHeight,
      bottomBezelHeight: bottomBezelHeight,
      resultRect: resultRect,
      screenshotRect: screenshotRect,
      phoneRect: phoneRect,
      showBackground: showBackground,
      type: type,
      phoneColor: phoneColor,
      phoneFrameColor: phoneFrameColor,
    );
  }
}
