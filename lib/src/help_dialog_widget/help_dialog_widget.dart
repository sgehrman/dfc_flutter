import 'package:dfc_flutter/src/help_dialog_widget/help_data.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_list.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_list_item.dart';
import 'package:dfc_flutter/src/widgets/paragraf.dart';
import 'package:flutter/material.dart';

class HelpDialogWidget extends StatelessWidget {
  const HelpDialogWidget({
    required this.data,
    required this.isMobile,
    this.title,
  });

  final List<HelpData> data;
  final bool isMobile;
  final ParagrafSpec? title;

  @override
  Widget build(BuildContext context) {
    int index = 0;
    final helpChildren = data.map(
      (x) {
        return HelpListItem(
          isMobile: isMobile,
          header: Paragraf(
            isMobile: isMobile,
            specs: [x.title],
          ),
          expanded: Paragraf(
            isMobile: isMobile,
            specs: [x.message],
          ),
          key: ValueKey(index++),
          initialExpanded: index == 1,
        );
      },
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Paragraf(
                specs: [
                  title!,
                ],
                isMobile: isMobile,
              ),
            ),
            const SizedBox(height: 20),
          ],
          HelpList(
            children: helpChildren,
          ),
        ],
      ),
    );
  }
}
