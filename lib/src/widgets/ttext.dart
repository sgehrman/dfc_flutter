import 'package:flutter/material.dart';

class TText extends Text {
  const TText(String? text, {TextStyle? style, TextAlign? textAlign})
      : super(text ?? 'null', style: style, textAlign: textAlign);
}
