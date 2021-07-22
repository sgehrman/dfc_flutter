import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  String? message,
  List<Widget> children = const <Widget>[],
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  bool barrierDismissible = true,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible, // can return null
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
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
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonName,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(okButtonName,
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ],
      );
    },
  );
}
