import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme themeWithGoogleFont(String fontName, TextTheme theme) {
  return GoogleFonts.getTextTheme(fontName, theme);
}

List<String> googleFonts() {
  return GoogleFonts.asMap().keys.toList();
}
