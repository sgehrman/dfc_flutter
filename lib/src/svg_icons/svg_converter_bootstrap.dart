// Regex to remove class garbage
// class=(["'])(?:(?=(\\?))\2.)*?\1

import 'dart:io';

import 'package:dfc_flutter/src/svg_icons/svg_converter_utils.dart';

// icons from:
// https://github.com/twbs/icons/tree/main/icons
Future<void> bootStrapConvert() async {
  final dir = Directory('/home/steve/expr/icons/icons');
  if (dir.existsSync()) {
    final result = dirListing('/home/steve/expr/material-icons/svg');

    final map = await buildIconMap(
      result,
      '',
    );

    await writeSvgOutput('/home/steve/expr/icons/output.dart', map);
  }
}
