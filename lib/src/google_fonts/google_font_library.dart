import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme themeWithGoogleFont(String fontName, TextTheme theme) {
  return GoogleFonts.getTextTheme(fontName, theme);
}

TextStyle styleWithGoogleFont(String fontName, TextStyle textStyle) {
  return GoogleFonts.getFont(fontName, textStyle: textStyle);
}

List<String> googleFonts() {
  return GoogleFonts.asMap().keys.toList();
}

// call this in main() to turn off http font fetching
void allowRuntimeFetching({required bool allow}) {
  GoogleFonts.config.allowRuntimeFetching = allow;
}
