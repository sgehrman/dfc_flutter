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
      const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
  EdgeInsets? titlePadding,
  EdgeInsets actionsPadding = const EdgeInsets.only(right: 10, bottom: 10),
  EdgeInsets contentPadding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      final focusNode = FocusNode();
      focusNode.attach(context);

      return KeyboardListener(
        focusNode: focusNode,
        autofocus: true,
        onKeyEvent: (keyEvent) {
          if (keyEvent is KeyDownEvent &&
              keyEvent.logicalKey == LogicalKeyboardKey.enter) {
            Navigator.of(context).pop(true);
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
          title: title == null ? null : Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              children: children,
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: showCancel,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.primary,
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
