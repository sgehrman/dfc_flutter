import 'package:dfc_flutter/src/widgets/tooltip_utils.dart';
import 'package:flutter/material.dart';

class MenuItemSpec extends StatelessWidget {
  const MenuItemSpec({
    required this.name,
    this.icon,
    this.level = 0,
    this.tooltip,
  });

  final String name;
  final Widget? icon;
  final int level;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 10;
    const double verticalPadding = 22;
    const double levelPadding = 20;

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

    return Tooltip(
      message: tipString(tooltip),
      waitDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: contentPadding,
        child: Row(
          children: [
            leading,
            const SizedBox(
              width: 34,
            ),
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
