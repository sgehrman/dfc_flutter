import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

String _fixText(String? text) {
  // cool hack so that the ellipsis doesn't break on words 'test this' => 'test...' with: 'test thi...'
  // this can make multiline breaks break between words which looks bad
  return (text ?? 'null').replaceAll(' ', '\u00A0').replaceAll('-', '\u{2011}');
}

class _TextBase extends Text {
  _TextBase({
    String? text,
    double? size,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    double? height,
    bool bold = false,
    Color? color,
    String? fontFamily,
  }) : super(
          _fixText(text),
          style: style != null
              ? style.copyWith(
                  fontSize: size,
                  fontFamily: fontFamily,
                  fontWeight: bold ? Font.bold : Font.normal,
                  color: color,
                  height: height,
                )
              : TextStyle(
                  fontSize: size,
                  fontFamily: fontFamily,
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
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold = false,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );

  static const double size = 12;
}

class Text16 extends _TextBase {
  Text16(
    String? text, {
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold = true,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );

  static const double size = 16;
}

class Text18 extends _TextBase {
  Text18(
    String? text, {
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold = true,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );

  static const double size = 18;
}

class Text20 extends _TextBase {
  Text20(
    String? text, {
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold = true,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );

  static const double size = 20;
}

class Text22 extends _TextBase {
  Text22(
    String? text, {
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold = true,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );

  static const double size = 22;
}

class TextWithSize extends _TextBase {
  TextWithSize(
    String? text,
    double size, {
    super.style,
    super.textAlign,
    super.maxLines,
    super.bold,
    super.color,
    super.height,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
        );
}

class TextTitle extends _TextBase {
  TextTitle(
    String? text, {
    super.style,
    super.textAlign = TextAlign.center,
    super.maxLines,
    super.bold = true,
    super.color,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
          height: 0.9,
        );

  static const double size = 58;
}

class TextSubtitle extends _TextBase {
  TextSubtitle(
    String? text, {
    super.style,
    super.textAlign = TextAlign.center,
    super.maxLines,
    super.bold = true,
    super.color,
    super.fontFamily,
  }) : super(
          text: text,
          size: size,
          height: 0.9,
        );

  static const double size = 28;
}
