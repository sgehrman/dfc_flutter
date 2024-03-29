import 'dart:async';

import 'package:flutter/material.dart';

Future<T?> showSimpleDialog<T>({
  required BuildContext context,
  required List<Widget> children,
  EdgeInsets contentPadding = const EdgeInsets.only(top: 12, bottom: 16),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeOut.transform(a1.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(0, -curvedValue * 200, 0),
        child: Opacity(
          opacity: a1.value,
          child: SimpleDialog(
            contentPadding: contentPadding,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            children: children,
          ),
        ),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
  );
}
