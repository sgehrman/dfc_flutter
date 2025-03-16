import 'package:dfc_flutter/dfc_flutter.dart';
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
  Color get outline => Theme.of(this).colorScheme.outline;
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;
  Color get scaffoldBackgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get dialogBackgroundColor =>
      Theme.of(this).dialogTheme.backgroundColor ?? surface;

  // text colors
  Color get textColor => onSurface;

  // light colors
  // Color get lightTextColor => onSurface.withValues(alpha: 0.8);
  // Color get dimTextColor => onSurface.withValues(alpha: 0.5);
  // Color get lightPrimary => primary.withValues(alpha: 0.4);

  // assuming that this draws more crisp text than using alpha above
  Color get lightTextColor => onSurface.mix(surface, 0.2);
  Color get dimTextColor => onSurface.mix(surface, 0.4);
  Color get lightPrimary => primary.mix(surface, 0.3);

  // in light mode, surfaceContainerLowest can be tinted and not pure white, use this instead
  // of surfaceContainerLowest, dark seems OK
  Color get surfaceContainerSuperLow =>
      Utils.isDarkMode(this) ? Colors.black : Colors.white;
}
