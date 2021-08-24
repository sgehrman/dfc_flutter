// Regex to remove class garbage
// class=(["'])(?:(?=(\\?))\2.)*?\1

import 'package:dfc_flutter/src/svg_icons/svg_converter_utils.dart';

// icons from:
// git clone git@github.com:google/material-design-icons.git
Future<void> communityConvert() async {
  final result = dirListing('/home/steve/expr/material-design-icons/src');

  final map = await buildIconMap(
    result,
    '',
  );

  await writeSvgOutput(
    '/home/steve/expr/material-design-icons/output.dart',
    map,
  );
}
