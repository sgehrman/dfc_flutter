import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogContentController<T> {
  Widget? widget;

  // Widget must set this
  T? Function()? resultCallback;

  void okTap(BuildContext context) {
    final result = resultCallback?.call();

    Navigator.of(context).pop(result);
  }
}

Future<T?> showContentDialog<T>({
  required BuildContext context,
  required Widget? title,
  required DialogContentController controller,
  bool showCancel = false,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  EdgeInsets titlePadding = const EdgeInsets.only(left: 30, top: 10),
  EdgeInsets actionsPadding = const EdgeInsets.only(right: 10, bottom: 10),
  EdgeInsets contentPadding = const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
}) {
  return showDialog<T>(
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
            controller.okTap(context);
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
          title: title,
          content: controller.widget,
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
                controller.okTap(context);
              },
              child: Text(okButtonName),
            ),
          ],
        ),
      );
    },
  );
}
