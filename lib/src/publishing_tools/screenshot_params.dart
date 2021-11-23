import 'package:dfc_flutter/src/publishing_tools/phone_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ScreenshotParams {
  ScreenshotParams({
    required this.imageAspectRatio,
    required this.titleBoxHeight,
    required this.footerBoxHeight,
    required this.phoneFrameWidth,
    required this.frameRadius,
    required this.imageFrameRadius,
    required this.topBezelHeight,
    required this.bottomBezelHeight,
    required this.resultRect,
    required this.screenshotRect,
    required this.phoneRect,
    required this.showBackground,
    required this.type,
    this.phoneColor = const Color.fromRGBO(0, 0, 0, 1),
    this.phoneFrameColor = const Color.fromRGBO(0, 0, 0, 1),
  });

  Color phoneColor;
  Color phoneFrameColor;
  PhoneType? type;
  Rect resultRect;
  bool showBackground;
  Rect screenshotRect;
  Rect phoneRect;
  double imageAspectRatio;
  double titleBoxHeight;
  double footerBoxHeight;
  double phoneFrameWidth;
  Radius frameRadius;
  Radius imageFrameRadius;
  double topBezelHeight;
  double bottomBezelHeight;

  @override
  String toString() {
    return '#### ScreenshotParams(type: $type,\nresultRect: $resultRect,\nshowBackground: $showBackground,\nscreenshotRect: $screenshotRect,\nphoneRect: $phoneRect,\nimageAspectRatio: $imageAspectRatio,\ntitleBoxHeight: $titleBoxHeight,\nfooterBoxHeight: $footerBoxHeight,\nphoneFrameWidth: $phoneFrameWidth,\nframeRadius: $frameRadius,\nimageFrameRadius: $imageFrameRadius,\ntopBezelHeight: $topBezelHeight,\nbottomBezelHeight: $bottomBezelHeight)';
  }
}
