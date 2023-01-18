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
  required DialogContentController<dynamic> controller,
  bool showCancel = false,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
  EdgeInsets insetPadding =
      const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  EdgeInsets titlePadding = const EdgeInsets.only(left: 30, top: 20),
  EdgeInsets actionsPadding = const EdgeInsets.only(right: 10, bottom: 10),
  EdgeInsets contentPadding = const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
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
