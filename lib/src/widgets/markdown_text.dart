import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.text, {
    this.fontSize = 16,
    this.onTapLink,
    this.textAlign = WrapAlignment.start,
  });

  final String? text;
  final double fontSize;
  final void Function(String text, String? href, String title)? onTapLink;
  final WrapAlignment textAlign;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: fontSize,
        );

    final aStyle = textStyle.copyWith(
      decorationColor: Theme.of(context).primaryColor,
    );

    return MarkdownBody(
      onTapLink: onTapLink ??
          (text, href, title) {
            Utils.launchUrl(href!);
          },
      styleSheet: MarkdownStyleSheet(
        blockSpacing: 8,
        textAlign: textAlign,
        a: aStyle,
        p: textStyle,
        h1: Theme.of(context).textTheme.headline1,
        h2: Theme.of(context).textTheme.headline2,
        h3: Theme.of(context).textTheme.headline3,
        h4: Theme.of(context).textTheme.headline4,
        h5: Theme.of(context).textTheme.headline5,
      ),
      data: text!,
    );
  }
}
