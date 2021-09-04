import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class DialogContent<T> {
  const DialogContent({
    required this.navigationResult,
    required this.widget,
  });

  final T Function() navigationResult;
  final Widget widget;
}

Future<T?> showContentDialog<T>({
  required BuildContext context,
  required String? title,
  required DialogContent content,
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
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return RawKeyboardListener(
        // its better to initialize and dispose of the focus node only for this alert dialog
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (v) {
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
          content: content.widget,
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
                  Navigator.of(context).pop();
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
                Navigator.of(context).pop(content.navigationResult());
              },
              child: Text(okButtonName),
            ),
          ],
        ),
      );
    },
  );
}
