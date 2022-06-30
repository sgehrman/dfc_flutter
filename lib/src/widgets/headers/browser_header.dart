import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/expandable_text.dart';
import 'package:dfc_flutter/src/widgets/headers/action_header.dart';
import 'package:flutter/material.dart';

class BrowserHeader extends StatelessWidget {
  const BrowserHeader(
    this.header, {
    this.top,
    this.bottom,
    this.subtitle,
  });

  const BrowserHeader.noPadding(
    this.header, {
    this.subtitle,
  })  : top = 0,
        bottom = 0;

  const BrowserHeader.equalPadding(
    this.header,
    double padding, {
    this.subtitle,
  })  : top = padding,
        bottom = padding;

  final String header;
  final double? top;
  final double? bottom;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    Widget subWidget = const NothingWidget();

    if (Utils.isNotEmpty(subtitle)) {
      subWidget = ExpandableText(
        subtitle,
        style: ActionHeader.defaultSubtitleStyle(context),
        maxLength: 220,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 14, top: top ?? 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header.toUpperCase(),
            style: ActionHeader.defaultTextStyle(context),
          ),
          subWidget,
        ],
      ),
    );
  }
}
