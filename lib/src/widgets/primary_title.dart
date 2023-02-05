import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/ttext.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

class PrimaryTitle extends StatelessWidget {
  const PrimaryTitle({
    required this.title,
    this.action,
  });

  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: TText(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: Font.bold,
                  ),
            ),
          ),
          action ?? const NothingWidget(),
        ],
      ),
    );
  }
}
