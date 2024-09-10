import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color mix(Color another, double amount) =>
      Color.lerp(this, another, amount) ?? Colors.red;

  // standard color scheme colors
  static Color primary(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color onPrimary(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color onPrimaryFixedVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimaryFixedVariant;
  static Color inversePrimary(BuildContext context) =>
      Theme.of(context).colorScheme.inversePrimary;
  static Color inverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.inverseSurface;
  static Color onInverseSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onInverseSurface;
  static Color surface(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color surfaceContainerHigh(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHigh;
  static Color surfaceContainerHighest(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;
  static Color surfaceContainerLowest(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLowest;
  static Color surfaceBright(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceBright;
  static Color onSurface(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
  static Color onSurfaceVariant(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;
  static Color surfaceContainer(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainer;
  static Color surfaceContainerLow(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerLow;
  static Color lightPrimary(BuildContext context, {double opacity = 0.4}) =>
      Theme.of(context).colorScheme.primary.withOpacity(opacity);
  static Color tertiary(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
  static Color tertiaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.tertiaryContainer;
  static Color onTertiary(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiary;
  static Color onTertiaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onTertiaryContainer;
  static Color secondary(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;
  static Color secondaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.secondaryContainer;
  static Color onSecondary(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondary;
  static Color onSecondaryContainer(BuildContext context) =>
      Theme.of(context).colorScheme.onSecondaryContainer;
}
