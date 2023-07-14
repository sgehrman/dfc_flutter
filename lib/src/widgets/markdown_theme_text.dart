import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownThemeText extends StatelessWidget {
  const MarkdownThemeText(
    this.markdownText, {
    required this.themeData,
    this.softLineBreak = false,
  });

  final String markdownText;
  final ThemeData themeData;
  final bool softLineBreak;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      onTapLink: (text, href, title) {
        Utils.launchUrl(href ?? '');
      },
      softLineBreak: softLineBreak,
      styleSheet: MarkdownStyleSheet.fromTheme(themeData),
      data: markdownText,
    );
  }
}
