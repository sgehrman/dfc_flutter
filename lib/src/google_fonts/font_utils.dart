import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontUtils {
  static TextTheme themeWithGoogleFont(String fontName, TextTheme theme) {
    return GoogleFonts.getTextTheme(fontName, theme);
  }

  static TextStyle styleWithGoogleFont(String fontName, TextStyle textStyle) {
    return GoogleFonts.getFont(fontName, textStyle: textStyle);
  }

  static List<String> googleFonts({bool includeItalic = false}) {
    final List<String> result = [];
    final map = GoogleFonts.asMap();

    for (final item in map.entries) {
      if (!includeItalic) {
        final d = item.value().fontStyle;

        if (d != FontStyle.italic) {
          result.add(item.key);
        }
      } else {
        result.add(item.key);
      }
    }

    return result;
  }

  // call this in main() to turn off http font fetching
  static set allowRuntimeFetching(bool allow) {
    GoogleFonts.config.allowRuntimeFetching = allow;
  }
}
