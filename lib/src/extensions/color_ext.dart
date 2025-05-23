import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color mix(Color another, double amount) =>
      Color.lerp(this, another, amount) ?? Colors.red;

  // factor >= 0 && factor <= 1
  Color lighter({double factor = 0.1}) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');

    final hslColor = HSLColor.fromColor(this);

    return hslColor
        .withLightness((hslColor.lightness * (1 + factor)).clamp(0.0, 1.0))
        .toColor();
  }

  // factor >= 0 && factor <= 1
  Color darker({double factor = 0.1}) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');

    final hslColor = HSLColor.fromColor(this);

    return hslColor
        .withLightness((hslColor.lightness * (1 - factor)).clamp(0.0, 1.0))
        .toColor();
  }

  // factor >= 0 && factor <= 1
  Color dimmer({double factor = 0.1}) {
    assert(factor >= 0 && factor <= 1, 'Factor must be between 0 and 1');

    final hslColor = HSLColor.fromColor(this);
    if (hslColor.lightness < 0.5) {
      return mix(Colors.white, factor);
    }

    return mix(Colors.black, factor);
  }
}
