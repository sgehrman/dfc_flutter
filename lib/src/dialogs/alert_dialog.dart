import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool barrierDismissible = true,
}) {
  const EdgeInsets actionsPadding = EdgeInsets.only(right: 10, bottom: 10);

  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      final focusNode = FocusNode();
      focusNode.attach(context);

      return KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (v) {
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
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    },
  );
}
