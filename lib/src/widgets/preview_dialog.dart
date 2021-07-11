import 'dart:async';
import 'package:flutter/material.dart';

Future<bool?> showPreviewDialog({
  required BuildContext context,
  required List<Widget> children,
  Color? backgroundColor,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) => CDialog(
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  );
}

class CDialog extends StatelessWidget {
  const CDialog({
    this.backgroundColor,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.clipBehavior = Clip.none,
    this.child,
  });

  final Color? backgroundColor;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final Clip clipBehavior;

  final Widget? child;

  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
    final DialogTheme dialogTheme = DialogTheme.of(context);

    final color = backgroundColor ??
        dialogTheme.backgroundColor ??
        Theme.of(context).dialogBackgroundColor;

    return AnimatedPadding(
      padding: EdgeInsets.zero,
      duration: insetAnimationDuration,
      curve: insetAnimationCurve,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .90,
              maxWidth: MediaQuery.of(context).size.width * .95),
          child: Material(
            color: Colors.transparent,
            elevation: dialogTheme.elevation ?? _defaultElevation,
            shape: dialogTheme.shape ?? _defaultDialogShape,
            type: MaterialType.card,
            clipBehavior: clipBehavior,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 4),
                color: Colors.black,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
