import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  List<Widget> children = const <Widget>[],
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
}) {
  const EdgeInsets actionsPadding = EdgeInsets.only(right: 10, bottom: 10);

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible, // can return null
    builder: (BuildContext context) {
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
          actionsPadding: actionsPadding,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          title: Text(title),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  if (Utils.isNotEmpty(message)) Text(message!),
                  ...children,
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
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
