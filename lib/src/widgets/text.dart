import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';

class _TextBase extends Text {
  _TextBase(
    String? text, {
    double? size,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool bold = false,
    Color? color,
  }) : super(
          // cool hack so that the ellipsis doesn't break on words 'test this' => 'test...' with: 'test thi...'
          (text ?? 'null').replaceAll(' ', '\u00A0'),
          style: style != null
              ? style.copyWith(
                  fontSize: size,
                  fontWeight: bold ? Font.bold : Font.normal,
                  color: color,
                  height: height,
                )
              : TextStyle(
                  fontSize: size,
                  fontWeight: bold ? Font.bold : Font.normal,
                  color: color,
                  height: height,
                ),
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: maxLines,
        );
}

class Text12 extends _TextBase {
  static const double size = 12;

  Text12(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = false,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
        );
}

class Text16 extends _TextBase {
  static const double size = 16;

  Text16(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
        );
}

class Text18 extends _TextBase {
  static const double size = 18;

  Text18(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
        );
}

class Text20 extends _TextBase {
  static const double size = 20;

  Text20(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
        );
}

class Text22 extends _TextBase {
  static const double size = 22;

  Text22(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
        );
}

class TextTitle extends _TextBase {
  static const double size = 70;

  TextTitle(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign = TextAlign.center,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
          height: 0.9,
        );
}

class TextSubtitle extends _TextBase {
  static const double size = 35;

  TextSubtitle(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign = TextAlign.center,
    int? maxLines,
    bool bold = true,
    Color? color,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
          height: 0.9,
        );
}
