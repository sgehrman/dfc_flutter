import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool?> showWidgetDialog({
  required BuildContext context,
  required String? title,
  required List<Widget> children,
  bool showCancel = false,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  EdgeInsets? titlePadding,
  EdgeInsets actionsPadding = const EdgeInsets.only(right: 10, bottom: 10),
  EdgeInsets contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return KeyboardListener(
        // its better to initialize and dispose of the focus node only for this alert dialog
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (v) {
          if (v.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.of(context).pop(true);
          }
        },

        child: AlertDialog(
          insetPadding: insetPadding,
          titlePadding: titlePadding,
          actionsPadding: actionsPadding,
          contentPadding: contentPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: title == null ? null : Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: showCancel,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(cancelButtonName),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(okButtonName),
            ),
          ],
        ),
      );
    },
  );
}
