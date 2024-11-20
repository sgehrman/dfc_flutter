import 'package:flutter/material.dart';

extension BuildContextUtils on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
  Color get onPrimaryFixedVariant =>
      Theme.of(this).colorScheme.onPrimaryFixedVariant;
  Color get inversePrimary => Theme.of(this).colorScheme.inversePrimary;
  Color get inverseSurface => Theme.of(this).colorScheme.inverseSurface;
  Color get onInverseSurface => Theme.of(this).colorScheme.onInverseSurface;
  Color get surface => Theme.of(this).colorScheme.surface;
  Color get surfaceContainerHigh =>
      Theme.of(this).colorScheme.surfaceContainerHigh;
  Color get surfaceContainerHighest =>
      Theme.of(this).colorScheme.surfaceContainerHighest;
  Color get surfaceContainerLowest =>
      Theme.of(this).colorScheme.surfaceContainerLowest;
  Color get surfaceBright => Theme.of(this).colorScheme.surfaceBright;
  Color get onSurface => Theme.of(this).colorScheme.onSurface;
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;
  Color get surfaceContainer => Theme.of(this).colorScheme.surfaceContainer;
  Color get surfaceContainerLow =>
      Theme.of(this).colorScheme.surfaceContainerLow;
  Color lightPrimary({double opacity = 0.4}) =>
      Theme.of(this).colorScheme.primary.withOpacity(opacity);
  Color get tertiary => Theme.of(this).colorScheme.tertiary;
  Color get tertiaryContainer => Theme.of(this).colorScheme.tertiaryContainer;
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;
  Color get onTertiaryContainer =>
      Theme.of(this).colorScheme.onTertiaryContainer;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get error => Theme.of(this).colorScheme.error;
  Color get onError => Theme.of(this).colorScheme.onError;
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;
  Color get onErrorContainer => Theme.of(this).colorScheme.onErrorContainer;
  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;
  Color get onSecondaryContainer =>
      Theme.of(this).colorScheme.onSecondaryContainer;
  Color get outlineVariant => Theme.of(this).colorScheme.outlineVariant;
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;

  // text colors
  Color get textColor => onSurface;
  Color get lightTextColor => onSurface.withOpacity(0.8);
  Color get dimTextColor => onSurface.withOpacity(0.5);
}
