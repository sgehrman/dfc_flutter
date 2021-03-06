// Regex to remove class garbage
// class=(["'])(?:(?=(\\?))\2.)*?\1

import 'package:dfc_flutter/src/svg_icons/svg_converter_utils.dart';

// icons from:
// https://fontawesome.com/ download
Future<void> fontawesomeConvert() async {
  final result =
      dirListing('/home/steve/expr/fontawesome-free-5.15.4-desktop/svgs');

  final map = await buildIconMap(
    result,
    '',
  );

  await writeSvgOutput(
    '/home/steve/expr/fontawesome-free-5.15.4-desktop/output.dart',
    map,
  );
}
