import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.text, {
    this.fontSize = 16,
  });

  final String? text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      onTapLink: (text, href, title) {
        Utils.launchUrl(href!);
      },
      styleSheet: MarkdownStyleSheet(
        blockSpacing: 8,
        p: TextStyle(fontSize: fontSize),
        h3: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: text!,
    );
  }
}
