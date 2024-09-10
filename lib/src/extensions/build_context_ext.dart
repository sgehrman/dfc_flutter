import 'package:flutter/material.dart';

extension BuildContextUtils on BuildContext {
  Color primary() => Theme.of(this).colorScheme.primary;
  Color onPrimary() => Theme.of(this).colorScheme.onPrimary;
  Color onPrimaryFixedVariant() =>
      Theme.of(this).colorScheme.onPrimaryFixedVariant;
  Color inversePrimary() => Theme.of(this).colorScheme.inversePrimary;
  Color inverseSurface() => Theme.of(this).colorScheme.inverseSurface;
  Color onInverseSurface() => Theme.of(this).colorScheme.onInverseSurface;
  Color surface() => Theme.of(this).colorScheme.surface;
  Color surfaceContainerHigh() =>
      Theme.of(this).colorScheme.surfaceContainerHigh;
  Color surfaceContainerHighest() =>
      Theme.of(this).colorScheme.surfaceContainerHighest;
  Color surfaceContainerLowest() =>
      Theme.of(this).colorScheme.surfaceContainerLowest;
  Color surfaceBright() => Theme.of(this).colorScheme.surfaceBright;
  Color onSurface() => Theme.of(this).colorScheme.onSurface;
  Color onSurfaceVariant() => Theme.of(this).colorScheme.onSurfaceVariant;
  Color surfaceContainer() => Theme.of(this).colorScheme.surfaceContainer;
  Color surfaceContainerLow() => Theme.of(this).colorScheme.surfaceContainerLow;
  Color lightPrimary(BuildContext context, {double opacity = 0.4}) =>
      Theme.of(this).colorScheme.primary.withOpacity(opacity);
  Color tertiary() => Theme.of(this).colorScheme.tertiary;
  Color tertiaryContainer() => Theme.of(this).colorScheme.tertiaryContainer;
  Color onTertiary() => Theme.of(this).colorScheme.onTertiary;
  Color onTertiaryContainer() => Theme.of(this).colorScheme.onTertiaryContainer;
  Color secondary() => Theme.of(this).colorScheme.secondary;
  Color secondaryContainer() => Theme.of(this).colorScheme.secondaryContainer;
  Color onSecondary() => Theme.of(this).colorScheme.onSecondary;
  Color onSecondaryContainer() =>
      Theme.of(this).colorScheme.onSecondaryContainer;
}
