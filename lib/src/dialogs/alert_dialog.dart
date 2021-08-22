import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool barrierDismissible = true,
}) {
  const EdgeInsets actionsPadding = EdgeInsets.only(bottom: 14);

  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return RawKeyboardListener(
        // its better to initialize and dispose of the focus node only for this alert dialog
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (v) {
          if (v.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.of(context).pop();
          }
        },

        child: AlertDialog(
          actionsPadding: actionsPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: SingleChildScrollView(
              child: Text(message),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      );
    },
  );
}
