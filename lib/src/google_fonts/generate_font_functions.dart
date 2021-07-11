import 'dart:io';

// to run
// $dart generate_font_functions
// creates output.dart in same directory

Future main() async {
  final File file = File(
      '/home/steve/.pub-cache/hosted/pub.dartlang.org/google_fonts-0.5.0+1/lib/google_fonts.dart');

  final String content = await file.readAsString();

  final List<String> lines = content.split('\n');

  String result = '';
  final themeNames = <String>[];

  result += "import 'package:google_fonts/google_fonts.dart';";
  result += "import 'package:flutter/material.dart';";
  result += 'TextTheme themeWithGoogleFont(String fontName, TextTheme theme) {';
  result += 'switch (fontName) {';

  for (final line in lines) {
    if (line.contains('Theme([TextTheme textTheme])')) {
      String substr = line.substring('  static TextTheme '.length);

      substr = substr.substring(
          0, substr.length - '([TextTheme textTheme]) {'.length);

      result += "\n case '$substr': return GoogleFonts.$substr(theme);";
      themeNames.add(substr);
    }
  }

  result += '}\n return theme; \n }';

  String themeNameFunct = '';
  themeNameFunct += 'List<String> googleFonts() { \n';
  themeNameFunct += 'return <String> [';
  themeNameFunct += "'${themeNames.join("', '")}'";
  themeNameFunct += '];\n}';

  result += '\n\n$themeNameFunct';

  final outFile = File('./output.dart');

  outFile.writeAsStringSync(result);
}
