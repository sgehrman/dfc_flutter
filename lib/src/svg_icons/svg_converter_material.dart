// Regex to remove class garbage
// class=(["'])(?:(?=(\\?))\2.)*?\1

import 'package:dfc_flutter/src/svg_icons/svg_converter_utils.dart';

// icons from:
// https://github.com/material-icons/material-icons
Future<void> materialConvert() async {
  final result = dirListing('/home/steve/expr/material-icons/svg');

  final map = await buildIconMap(
    result,
    '',
  );

  await writeSvgOutput('/home/steve/expr/material-icons/output.dart', map);
}
