import 'dart:ui' as ui;
import 'package:flutter/material.dart';

final Sizes kFontSize = Sizes.fonts();
final Sizes kIconSize = Sizes.icons();

class Sizes {
  const Sizes({
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
  });

  // tried to make this const, but doesn't seem provide what I need
  // ex: const bool isProduction = bool.fromEnvironment('dart.vm.product');

  factory Sizes.fonts() {
    final window = WidgetsBinding.instance?.window ?? ui.window;
    final pixelRatio = window.devicePixelRatio;

    // // smaller fonts for mac desktop
    // if (Utils.isMacOS) {
    //   return const Sizes(
    //     s: 12,
    //     m: 14,
    //     l: 18,
    //     xl: 30,
    //   );
    // }

    return Sizes(
      s: 14 / pixelRatio,
      m: 16 / pixelRatio,
      l: 20 / pixelRatio,
      xl: 40 / pixelRatio, // used for quote
    );
  }

  factory Sizes.icons() {
    final window = WidgetsBinding.instance?.window ?? ui.window;
    final pixelRatio = window.devicePixelRatio;

    // smaller fonts for mac desktop
    // if (Utils.isMacOS) {
    //   return const Sizes(
    //     s: 18,
    //     m: 22,
    //     l: 32,
    //     xl: 42,
    //   );
    // }

    return Sizes(
      s: 18 / pixelRatio,
      m: 22 / pixelRatio,
      l: 32 / pixelRatio,
      xl: 42 / pixelRatio,
    );
  }

  final double s;
  final double m;
  final double l;
  final double xl;
}
