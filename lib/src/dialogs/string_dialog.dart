import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

Future<String?> showStringDialog({
  required BuildContext context,
  required String title,
  String? message,
  String okButtonName = 'OK',
  String cancelButtonName = 'Cancel',
  String defaultName = '',
  TextInputType keyboardType = TextInputType.text,
  bool barrierDismissible = true,
  int minLines = 1,
  int maxLines = 1,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible, // if true, null can be returned
    builder: (context) {
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
  final String defaultName;
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

    _textController!.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.defaultName.length,
    );
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

  void _okClick(String text) {
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    const actionsPadding = EdgeInsets.only(right: 10, bottom: 10);

    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      actionsPadding: actionsPadding,
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              ..._message(),
              TextField(
                keyboardType: widget.keyboardType,
                autofocus: true,
                onSubmitted: _okClick,
                controller: _textController,
                minLines: widget.minLines,
                maxLines: widget.minLines,
              ),
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
            Navigator.of(context).pop();
          },
          child: Text(widget.cancelButtonName),
        ),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),
          onPressed: () => _okClick(_textController!.text),
          child: Text(widget.okButtonName),
        ),
      ],
    );
  }
}
