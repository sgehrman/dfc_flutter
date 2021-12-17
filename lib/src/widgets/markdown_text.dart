import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      onTapLink: (text, href, title) {
        Utils.launchUrl(href!);
      },
      styleSheet: MarkdownStyleSheet(
        blockSpacing: 8,
        p: const TextStyle(fontSize: 16),
        h3: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: text!,
    );
  }
}
