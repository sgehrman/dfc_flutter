import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';

String _fixText(String? text) {
  // cool hack so that the ellipsis doesn't break on words 'test this' => 'test...' with: 'test thi...'
  // this can make multiline breaks break between words which looks bad
  return (text ?? 'null').replaceAll(' ', '\u00A0');
}

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
          _fixText(text),
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
  Text12(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = false,
    Color? color,
    double? height,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          textAlign: textAlign,
          maxLines: maxLines,
          height: height,
        );

  static const double size = 12;
}

class Text16 extends _TextBase {
  Text16(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
    double? height,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          height: height,
          textAlign: textAlign,
          maxLines: maxLines,
        );

  static const double size = 16;
}

class Text18 extends _TextBase {
  Text18(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
    double? height,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          height: height,
          textAlign: textAlign,
          maxLines: maxLines,
        );

  static const double size = 18;
}

class Text20 extends _TextBase {
  Text20(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
    double? height,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          height: height,
          textAlign: textAlign,
          maxLines: maxLines,
        );

  static const double size = 20;
}

class Text22 extends _TextBase {
  Text22(
    String? text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    bool bold = true,
    Color? color,
    double? height,
  }) : super(
          text,
          style: style,
          bold: bold,
          color: color,
          size: size,
          height: height,
          textAlign: textAlign,
          maxLines: maxLines,
        );

  static const double size = 22;
}

class TextTitle extends _TextBase {
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

  static const double size = 70;
}

class TextSubtitle extends _TextBase {
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

  static const double size = 35;
}
