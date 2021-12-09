import 'package:dfc_flutter/src/publishing_tools/phone_menu.dart';
import 'package:dfc_flutter/src/publishing_tools/screenshot_params.dart';
import 'package:flutter/material.dart';

class PhoneShapes {
  static const Color cameraColor = Color.fromRGBO(70, 70, 70, 1);
  static double speakerHeight = 20;
  static Paint dotPaint = Paint()..color = cameraColor;

  static void drawTopBezelApplePhone({
    required Canvas canvas,
    required double centerX,
    required double centerY,
    required double startY,
  }) {
    // speaker
    final RRect speakerRRect =
        drawSpeaker(canvas: canvas, centerX: centerX, startY: centerY);

    // camera dot
    drawFramedCircle(
      canvas: canvas,
      radius: 16,
      centerX: speakerRRect.left - 58,
      centerY: speakerRRect.top + (speakerHeight / 2),
    );

    // face detect dot
    drawFramedCircle(
      canvas: canvas,
      radius: 12,
      centerX: centerX,
      centerY: startY + 4,
    );
  }

  static void drawTopBezelAppleTablet({
    required Canvas canvas,
    required double centerX,
    required double centerY,
    required double startY,
  }) {
    // camera dot
    drawFramedCircle(
      canvas: canvas,
      radius: 18,
      centerX: centerX,
      centerY: centerY,
    );
  }

  static void drawFramedCircle({
    required Canvas canvas,
    required double centerX,
    required double centerY,
    required double radius,
  }) {
    // camera dot
    final Paint camPaint = Paint();
    camPaint.color = cameraColor;
    camPaint.style = PaintingStyle.stroke;
    camPaint.strokeWidth = 5;

    final Paint camFillPaint = Paint();
    camFillPaint.color = Colors.white12;

    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      camFillPaint,
    );
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      camPaint,
    );
  }

  static RRect drawSpeaker({
    required Canvas canvas,
    required double centerX,
    required double startY,
  }) {
    const speakerHalfW = 78;
    final RRect speakerRRect = RRect.fromLTRBR(
      centerX - speakerHalfW,
      startY - speakerHeight / 2,
      centerX + speakerHalfW,
      startY + speakerHeight / 2,
      const Radius.circular(10),
    );

    final Paint camPaint = Paint();
    camPaint.color = cameraColor;
    camPaint.style = PaintingStyle.stroke;
    camPaint.strokeWidth = 5;

    final Paint camFillPaint = Paint();
    camFillPaint.color = const Color.fromRGBO(0, 0, 0, .35);

    canvas.drawRRect(speakerRRect, camPaint);

    canvas.drawRRect(speakerRRect, camFillPaint);

    return speakerRRect;
  }

  static void drawNotch({
    required ScreenshotParams params,
    required Canvas canvas,
    required bool appleNotch,
    required double centerX,
    required double startY,
  }) {
    final Paint notchPaint = Paint();
    notchPaint.color = params.phoneColor;

    if (appleNotch) {
      canvas.drawPath(iPhoneNotchPath(centerX, startY), notchPaint);
    } else {
      canvas.drawPath(onePlusNotchPath(centerX, startY), notchPaint);
    }

    // draw camera dot
    if (appleNotch) {
      // speaker
      final RRect speakerRRect =
          drawSpeaker(canvas: canvas, centerX: centerX, startY: startY + 24);

      drawFramedCircle(
        canvas: canvas,
        radius: 16,
        centerX: speakerRRect.right + 58,
        centerY: speakerRRect.top + (speakerHeight / 2),
      );
    } else {
      const double cameraRadius = 12;

      canvas.drawCircle(Offset(centerX, startY + 23), cameraRadius, dotPaint);
    }
  }

  static void drawPhoneButtons(Canvas canvas, ScreenshotParams params) {
    final Paint paint = Paint();
    paint.color = params.phoneColor;
    const double volButtonW = 100;
    const double volButtonH = 184;
    const double muteButtonH = 100;
    double volButtonY = params.phoneRect.top + 300;
    const double stickout = 16;
    const r = Radius.circular(10);
    Rect rect;

    bool drawMuteSwitch = false;
    bool drawButtons = false;
    switch (params.type) {
      case PhoneType.iPhone11:
      case PhoneType.iPhone5:
        drawMuteSwitch = true;
        drawButtons = true;
        break;
      case PhoneType.onePlus7t:
        drawButtons = true;
        break;
      case PhoneType.iPad:
      case PhoneType.iPadPro:
        break;
      default:
        break;
    }

    // mute switch
    if (drawMuteSwitch) {
      rect = Rect.fromLTWH(
        params.phoneRect.left - stickout,
        volButtonY,
        volButtonW,
        muteButtonH,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);
    }

    if (drawButtons) {
      volButtonY += muteButtonH;
      volButtonY += 82;

      // volume top
      rect = Rect.fromLTWH(
        params.phoneRect.left - stickout,
        volButtonY,
        volButtonW,
        volButtonH,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);

      volButtonY += volButtonH;
      volButtonY += 52;

      // volume bottom
      rect = Rect.fromLTWH(
        params.phoneRect.left - stickout,
        volButtonY,
        volButtonW,
        volButtonH,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);

      // power button
      volButtonY = params.phoneRect.top + 563;
      rect = Rect.fromLTWH(
        params.phoneRect.right - (volButtonW - stickout),
        volButtonY,
        volButtonW,
        volButtonH * 1.5,
      );
      canvas.drawRRect(RRect.fromRectAndRadius(rect, r), paint);
    }
  }

  static Path onePlusNotchPath(double centerX, double startY) {
    final Path notchPath = Path();
    final double notchY = startY + 50;
    const double notchWidth = 80;
    const double notchHalf = notchWidth / 2;

    notchPath.moveTo(centerX - notchWidth, startY);

    notchPath.cubicTo(
      centerX - notchHalf,
      startY,
      centerX - notchHalf,
      notchY,
      centerX,
      notchY,
    );

    notchPath.cubicTo(
      centerX + notchHalf,
      notchY,
      centerX + notchHalf,
      startY,
      centerX + notchWidth,
      startY,
    );

    notchPath.close();

    return notchPath;
  }

  static Path iPhoneNotchPath(double centerX, double startY) {
    const double curveLen = 70;
    const double smallCurveLen = 26;
    const double notchWidth = 680;
    const double notchHeight = 86;

    final Path notchPath = Path();
    final double notchY = startY + notchHeight;
    const double notchHalf = notchWidth / 2;
    final double leftX = centerX - notchHalf;
    final double rightX = centerX + notchHalf;

    notchPath.moveTo(leftX - smallCurveLen, startY);

    notchPath.quadraticBezierTo(
      leftX,
      startY,
      leftX,
      startY + smallCurveLen,
    );

    notchPath.lineTo(leftX, notchY - curveLen);

    notchPath.quadraticBezierTo(
      leftX,
      notchY,
      leftX + curveLen,
      notchY,
    );

    notchPath.lineTo(rightX - curveLen, notchY);

    notchPath.quadraticBezierTo(
      rightX,
      notchY,
      rightX,
      notchY - curveLen,
    );

    notchPath.lineTo(rightX, startY + smallCurveLen);

    notchPath.quadraticBezierTo(
      rightX,
      startY,
      rightX + smallCurveLen,
      startY,
    );

    notchPath.close();

    return notchPath;
  }

  static void drawPhoneNotch({
    required Canvas canvas,
    required PhoneType? type,
    required double centerX,
    required ScreenshotParams params,
  }) {
    switch (type) {
      case PhoneType.iPhone11:
        drawNotch(
          params: params,
          canvas: canvas,
          appleNotch: true,
          centerX: centerX,
          startY: params.screenshotRect.top,
        );
        break;
      case PhoneType.onePlus7t:
        drawNotch(
          params: params,
          canvas: canvas,
          appleNotch: false,
          centerX: centerX,
          startY: params.screenshotRect.top,
        );
        break;
      case PhoneType.iPadPro:
        drawFramedCircle(
          radius: 12,
          canvas: canvas,
          centerX: centerX,
          centerY: params.screenshotRect.top - (params.phoneFrameWidth / 2),
        );
        break;
      case PhoneType.iPad:
        drawTopBezelAppleTablet(
          canvas: canvas,
          centerX: centerX,
          centerY: params.screenshotRect.top -
              ((params.topBezelHeight + params.phoneFrameWidth) / 2),
          startY: params.screenshotRect.top - params.topBezelHeight,
        );

        // home button
        drawFramedCircle(
          radius: 62,
          canvas: canvas,
          centerX: centerX,
          centerY: params.screenshotRect.bottom +
              ((params.bottomBezelHeight + params.phoneFrameWidth) / 2),
        );
        break;
      case PhoneType.iPhone5:
        drawTopBezelApplePhone(
          canvas: canvas,
          centerX: centerX,
          centerY: params.screenshotRect.top -
              ((params.topBezelHeight + params.phoneFrameWidth) / 2),
          startY: params.screenshotRect.top - params.topBezelHeight,
        );

        // home button
        drawFramedCircle(
          radius: 68,
          canvas: canvas,
          centerX: centerX,
          centerY: params.screenshotRect.bottom +
              ((params.bottomBezelHeight + params.phoneFrameWidth) / 2),
        );
        break;
      default:
        break;
    }
  }
}
