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
    return const Sizes(
      s: 14,
      m: 16,
      l: 20,
      xl: 40, // used for quote
    );
  }

  factory Sizes.icons() {
    return const Sizes(
      s: 20,
      m: 24,
      l: 32,
      xl: 42,
    );
  }

  final double s;
  final double m;
  final double l;
  final double xl;
}
