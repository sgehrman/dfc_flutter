import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/linkify_text/linkify.dart';
import 'package:flutter/material.dart';

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
      return LinkifySelectableText(
        text,
        linkStyle: linkStyle ?? style.copyWith(color: context.primary),
        linkTypes: const [
          LinkType.url,
          // LinkType.hashTag,
          LinkType.email,
          LinkType.phone,
          LinkType.file,
          // LinkType.userTag,
        ],
        textStyle: style,
        onTap: (link) {
          if (Utils.isNotEmpty(link.value)) {
            Utils.launchUrl(link.value ?? '');
          }
        },
      );
    }
    return LinkifyText(
      text,
      linkStyle: linkStyle ?? style.copyWith(color: context.primary),
      linkTypes: const [
        LinkType.url,
        // LinkType.hashTag,
        LinkType.email,
        LinkType.phone,
        LinkType.file,
        // LinkType.userTag,
      ],
      textStyle: style,
      onTap: (link) {
        if (Utils.isNotEmpty(link.value)) {
          Utils.launchUrl(link.value ?? '');
        }
      },
    );
  }
}
