import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(this.text, {this.style, this.linkStyle, super.key});

  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;

  Future<void> _onOpen(LinkableElement link) async {
    await Utils.launchUrl(link.url);
  }

  @override
  Widget build(BuildContext context) {
    return SelectableLinkify(
      onOpen: _onOpen,
      style: style,
      linkStyle: linkStyle ?? const TextStyle(color: Colors.cyan),
      text: text,
    );
  }
}
