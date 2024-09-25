import 'package:dfc_flutter/src/help_dialog_widget/help_list_item.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/shrink_wrapped_list.dart';
import 'package:flutter/material.dart';

class HelpList extends StatelessWidget {
  const HelpList({
    required this.children,
  });

  final List<HelpListItem> children;

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(children)) {
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
