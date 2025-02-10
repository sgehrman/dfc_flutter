import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:linkify_plus/linkify_plus.dart';

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(
    this.text, {
    required this.style,
    this.humanize = false,
    this.selectable = false,
    this.linkStyle,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextStyle? linkStyle;
  final bool selectable;
  final bool humanize;

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectableLinkify(
        text: text,
        linkStyle: linkStyle ?? style.copyWith(color: context.primary),
        options: LinkifyOptions(humanize: humanize),
        style: style,
        onOpen: (link) {
          if (Utils.isNotEmpty(link.url)) {
            Utils.launchUrl(link.url);
          }
        },
      );
    }
    return Linkify(
      text: text,
      linkStyle: linkStyle ?? style.copyWith(color: context.primary),
      options: LinkifyOptions(humanize: humanize),
      style: style,
      onOpen: (link) {
        if (Utils.isNotEmpty(link.url)) {
          Utils.launchUrl(link.url);
        }
      },
    );
  }
}
