import 'package:dfc_flutter/src/dialogs/keyboard_and_mouse_events.dart';
import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

Future<String?> showStringDialog({
  required BuildContext context,
  required String title,
  String? message,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  String? defaultName = '',
  TextInputType keyboardType = TextInputType.text,
  bool barrierDismissible = true,
  int minLines = 1,
  int maxLines = 1,
}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible, // if true, null can be returned
    builder: (BuildContext context) {
      return _DialogContents(
        title: title,
        message: message,
        okButtonName: okButtonName,
        defaultName: defaultName,
        cancelButtonName: cancelButtonName,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
      );
    },
  );
}

class _DialogContents extends StatefulWidget {
  const _DialogContents({
    required this.title,
    this.message,
    this.okButtonName = 'OK',
    this.cancelButtonName = 'Cancel',
    this.defaultName = '',
    this.keyboardType = TextInputType.text,
    this.minLines,
    this.maxLines,
  });

  final String title;
  final String? message;
  final String? defaultName;
  final String okButtonName;
  final String cancelButtonName;
  final TextInputType keyboardType;
  final int? minLines;
  final int? maxLines;

  @override
  __DialogContentsState createState() => __DialogContentsState();
}

class __DialogContentsState extends State<_DialogContents> {
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController(text: widget.defaultName);
  }

  @override
  void dispose() {
    _textController!.dispose();

    super.dispose();
  }

  List<Widget> _message() {
    if (Utils.isNotEmpty(widget.message)) {
      return [Text(widget.message!), const SizedBox(height: 10)];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(widget.title),
      content: KeyboardAndMouseEvents(
        onEnterCallback: () {
          Navigator.of(context).pop(_textController!.text);
        },
        onEscCallback: () {
          Navigator.of(context).pop();
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ..._message(),
                TextField(
                  keyboardType: widget.keyboardType,
                  autofocus: true,
                  controller: _textController,
                  minLines: widget.minLines,
                  maxLines: widget.minLines,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(widget.cancelButtonName,
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_textController!.text);
          },
          child: Text(widget.okButtonName,
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ],
    );
  }
}
