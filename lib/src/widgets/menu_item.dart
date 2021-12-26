import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
    this.onTap, // not needed in a PopupMenuItem
    this.large = false,
  });

  final String name;
  final Widget? icon;
  final int level;
  final void Function()? onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = 10;
    double verticalPadding = 4;
    double levelPadding = 20;

    if (large) {
      horizontalPadding = 24;
      verticalPadding = 14;
      levelPadding = 20;
    }

    final contentPadding = EdgeInsets.only(
      right: horizontalPadding,
      left: horizontalPadding + (level * levelPadding),
      top: verticalPadding,
      bottom: verticalPadding,
    );

    Widget leading = const SizedBox();
    if (icon != null) {
      leading = icon!;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: contentPadding,
        child: Row(
          children: [
            leading,
            const SizedBox(
              width: 14,
            ),
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
