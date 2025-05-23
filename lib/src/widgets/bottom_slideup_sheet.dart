import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

abstract class SliderContent {
  int itemCount();
  void dispose();
  String stringForCopy();
  Widget itemBuilder(BuildContext context, int index);
  Widget buttonBarBuilder(BuildContext context);
  bool enableCopyButton();
  double get initialChildSize;
  Color backgroundColor(BuildContext context);
  Color barrierColor(BuildContext context);
  Widget listView(BuildContext context, ScrollController controller);
}

const BorderRadius _borderRadius = BorderRadius.only(
  topLeft: Radius.circular(30),
  topRight: Radius.circular(30),
);

class BottomSlideupSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required SliderContent sliderContent,
  }) {
    return showModalBottomSheet<T>(
      backgroundColor: sliderContent.backgroundColor(context),
      barrierColor: sliderContent.barrierColor(context),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
      context: context,
      builder: (context) {
        return _SheetList(sliderContent: sliderContent);
      },
    );
  }
}

class _SheetList extends StatelessWidget {
  const _SheetList({this.sliderContent});

  final SliderContent? sliderContent;

  Widget _tabDecoration(BuildContext context) {
    return Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: Utils.isDarkMode(context) ? Colors.grey[600] : Colors.grey[400],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Widget _buttonBar(BuildContext context) {
    Widget copyButton = const NothingWidget();

    if (sliderContent!.enableCopyButton()) {
      copyButton = InkWell(
        onTap: () {
          final jsonStr = sliderContent!.stringForCopy();

          Utils.copyToClipboard(jsonStr);
        },
        child: const Icon(Icons.content_copy, size: 26),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[sliderContent!.buttonBarBuilder(context), copyButton],
    );
  }

  Widget _listView(BuildContext context, ScrollController controller) {
    final listview = sliderContent?.listView(context, controller);

    if (listview != null) {
      return listview;
    }

    return ListView.builder(
      controller: controller,
      itemBuilder: sliderContent!.itemBuilder,
      itemCount: sliderContent!.itemCount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, right: 20, left: 20),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: sliderContent!.initialChildSize,
        maxChildSize: 0.9,
        minChildSize: 0.2,
        builder: (context, controller) {
          // Material is needed for Ink splashes
          return Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _tabDecoration(context),
                const SizedBox(height: 8),
                _buttonBar(context),
                Expanded(child: _listView(context, controller)),
              ],
            ),
          );
        },
      ),
    );
  }
}
