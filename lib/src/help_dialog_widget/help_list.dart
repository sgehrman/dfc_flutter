import 'package:dfc_flutter/src/help_dialog_widget/help_data.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_list_item.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/shrink_wrapped_list.dart';
import 'package:flutter/material.dart';

class HelpList extends StatelessWidget {
  const HelpList({
    required this.helpData,
    required this.isMobile,
  });

  final List<HelpData> helpData;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(helpData)) {
      final children = HelpListItem.itemsFromHelpData(
        helpData: helpData,
        isMobile: isMobile,
      );

      return ShrinkWrappedList(
        separatorBuilder: null,
        itemBuilder: (context, index) {
          return children[index];
        },
        itemCount: children.length,
      );
    } else {
      return const Center(
        child: Text('Nothing Found'),
      );
    }
  }
}
