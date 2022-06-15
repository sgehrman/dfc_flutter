import 'package:dfc_flutter/src/dialogs/content_dialog.dart';
import 'package:dfc_flutter/src/utils/string_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/json_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonViewerScreen extends StatelessWidget {
  const JsonViewerScreen({
    required this.map,
    required this.title,
    this.onDelete,
  });

  final Map<String, dynamic> map;
  final String title;
  final VoidCallback? onDelete;

  static Future<void> show({
    required BuildContext context,
    required Map<String, dynamic> map,
    required String title,
    VoidCallback? onDelete,
  }) async {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) {
          return JsonViewerScreen(
            map: map,
            title: title,
            onDelete: onDelete,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  Widget _copyButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        final String jsonStr = StrUtils.toPrettyString(map);
        Clipboard.setData(ClipboardData(text: jsonStr));

        Utils.showCopiedToast(context);
      },
      icon: const Icon(
        Icons.content_copy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    if (onDelete != null) {
      actions = [
        IconButton(
          iconSize: 18,
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ];
    }

    actions.add(_copyButton(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: JsonViewerWidget(map),
      ),
    );
  }
}

// Future<void> showJsonViewerDialog({
//   required BuildContext context,
//   required Map<String, dynamic> map,
//   required String title,
// }) {
//   return showWidgetDialog(
//     context: context,
//     title: title,
//     children: [JsonViewerWidget(map)],
//   );
// }

Future<void> showJsonViewerDialog({
  required BuildContext context,
  required Map<String, dynamic> map,
  required String title,
  Function()? onDelete,
}) {
  final controller = DialogContentController<void>();

  controller.widget = Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Utils.isDarkMode(context)
          ? Colors.white.withOpacity(0.07)
          : Colors.black.withOpacity(0.07),
    ),
    padding: const EdgeInsets.all(10),
    height: 700,
    width: 600,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: JsonViewerWidget(map),
    ),
  );

  return showContentDialog<void>(
    context: context,
    title: Row(
      children: [
        Text(title),
        const Spacer(),
        IconButton(
          onPressed: onDelete,
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outlined),
        ),
        IconButton(
          onPressed: () {
            final String jsonStr = StrUtils.toPrettyString(map);
            Clipboard.setData(ClipboardData(text: jsonStr));

            Utils.showCopiedToast(context);
          },
          tooltip: 'Copy Json',
          icon: const Icon(Icons.content_copy),
        ),
      ],
    ),
    okButtonName: 'Close',
    showCancel: false,
    controller: controller,
  );
}
