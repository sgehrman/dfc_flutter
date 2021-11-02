import 'package:flutter/material.dart';

class TransparentAppBarTheme extends StatelessWidget {
  const TransparentAppBarTheme({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // disable if elevation is set
    if (theme.appBarTheme.elevation == 0) {
      final newAppBar = theme.appBarTheme.copyWith(
        color: Colors.transparent,
      );

      final ThemeData newTheme = theme.copyWith(
        appBarTheme: newAppBar,
      );

      return Theme(
        data: newTheme,
        child: child,
      );
    }

    return child;
  }
}
