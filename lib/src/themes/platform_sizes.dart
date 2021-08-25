import 'package:dfc_flutter/src/utils/utils.dart';

final Sizes kFontSize = Sizes.fonts();
final Sizes kIconSize = Sizes.icons();

class Sizes {
  const Sizes({
    required this.s,
    required this.m,
    required this.l,
  });

  // tried to make this const, but doesn't seem provide what I need
  // ex: const bool isProduction = bool.fromEnvironment('dart.vm.product');

  factory Sizes.fonts() {
    // smaller fonts for mac desktop
    if (Utils.isMacOS) {
      return const Sizes(s: 12, m: 14, l: 18);
    }

    return const Sizes(s: 14, m: 16, l: 20);
  }

  factory Sizes.icons() {
    // smaller fonts for mac desktop
    if (Utils.isMacOS) {
      return const Sizes(s: 18, m: 22, l: 32);
    }

    return const Sizes(s: 18, m: 22, l: 32);
  }

  final double s;
  final double m;
  final double l;
}
