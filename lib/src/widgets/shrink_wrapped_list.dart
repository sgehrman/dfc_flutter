import 'package:flutter/material.dart';

class ShrinkWrappedList extends StatelessWidget {
  const ShrinkWrappedList({
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    super.key,
  });

  final int itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget? Function(BuildContext, int)? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    final showingSeparators = separatorBuilder != null;

    final numDividers = itemCount - 1;
    int separatorIndex = 0;
    int contentIndex = 0;

    return CustomScrollView(
      primary: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (showingSeparators && index % 2 != 0) {
                return separatorBuilder!(context, separatorIndex++);
              }

              return itemBuilder(context, contentIndex++);
            },
            childCount: showingSeparators ? itemCount + numDividers : itemCount,
          ),
        ),
      ],
    );
  }
}
