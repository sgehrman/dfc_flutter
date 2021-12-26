import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    required this.name,
    this.icon,
    this.level = 0,
    this.onTap, // not needed in a PopupMenuItem
    this.horizontalPadding = 16,
    this.levelPadding = 20,
    this.enabled = true,
  });

  final String name;
  final Widget? icon;
  final bool enabled;
  final int level;
  final void Function()? onTap;
  final double horizontalPadding;
  final double levelPadding;

  @override
  Widget build(BuildContext context) {
    final contentPadding = EdgeInsets.only(
      right: horizontalPadding,
      left: horizontalPadding + (level * levelPadding),
      top: 4,
      bottom: 4,
    );

    Widget leading = const SizedBox();
    if (icon != null) {
      leading = icon!;
    }

    Color textColor =
        Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;

    if (!enabled) {
      textColor = textColor.withOpacity(.5);
    }

    return InkWell(
      onTap: enabled ? onTap : null,
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
                style: TextStyle(
                  color: textColor,
                ),
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
