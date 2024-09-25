import 'package:dfc_flutter/src/xpandable/xpandable_button.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_controller.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_icon.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme_notifier.dart';
import 'package:flutter/material.dart';

typedef XpandableBuilder = Widget Function(
  BuildContext context,
  Widget expanded,
);

class XpandablePanel extends StatelessWidget {
  const XpandablePanel({
    required this.header,
    required this.expanded,
    required this.builder,
    required this.isMobile,
    required XpandableThemeData theme,
    this.controller,
    this.onExpand,
  }) : _theme = theme;

  final Widget header;
  final Widget expanded;
  final XpandableBuilder builder;
  final void Function()? onExpand;
  final XpandableController? controller;
  final XpandableThemeData _theme;
  final bool isMobile;

  Widget _buildWithHeader(
    BuildContext context,
    XpandableThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: theme.headerDecoration,
          clipBehavior: Clip.antiAlias,
          child: XpandableButton(
            theme: _theme,
            child: Row(
              children: [
                XpandableIcon(theme: theme),
                SizedBox(width: isMobile ? 5 : 8),
                Expanded(
                  child: header,
                ),
              ],
            ),
          ),
        ),
        builder(
          context,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (onExpand != null) {
                onExpand?.call();
              }

              final controller = XpandableController.of(context);
              controller?.toggle();
            },
            child: expanded,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = XpandableThemeData.withDefaults(_theme);

    final panel = _buildWithHeader(context, theme);

    if (controller != null) {
      return XpandableNotifier(
        controller: controller,
        child: panel,
      );
    } else {
      final controller =
          XpandableController.of(context, rebuildOnChange: false);
      if (controller == null) {
        return XpandableNotifier(
          controller: controller,
          child: panel,
        );
      } else {
        return panel;
      }
    }
  }
}
