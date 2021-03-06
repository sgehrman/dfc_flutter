import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.text, {
    this.fontSize = 16,
    this.onTapLink,
    this.textAlign = WrapAlignment.start,
    this.softLineBreak = false,
  });

  final String? text;
  final double fontSize;
  final bool softLineBreak;
  final void Function(String text, String? href, String title)? onTapLink;
  final WrapAlignment textAlign;

  @override
  Widget build(BuildContext context) {
    // bodyText2 since bodyText1 might be bold
    final textStyle = Theme.of(context).textTheme.bodyText2!.copyWith(
          fontSize: fontSize,
        );

    final aStyle = textStyle.copyWith(
      decorationColor: Theme.of(context).primaryColor,
      color: Theme.of(context).primaryColor,
    );

    final boldStyle = textStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    return MarkdownBody(
      onTapLink: onTapLink ??
          (text, href, title) {
            Utils.launchUrl(href!);
          },
      softLineBreak: softLineBreak,
      styleSheet: MarkdownStyleSheet(
        blockSpacing: 8,
        textAlign: textAlign,
        a: aStyle,
        p: textStyle,
        h1Padding: const EdgeInsets.only(bottom: 6),
        h2Padding: const EdgeInsets.only(bottom: 6),
        h3Padding: const EdgeInsets.only(bottom: 6),
        h4Padding: const EdgeInsets.only(bottom: 6),
        h5Padding: const EdgeInsets.only(bottom: 6),
        h6Padding: const EdgeInsets.only(bottom: 6),
        pPadding: const EdgeInsets.only(bottom: 6),
        strong: boldStyle,
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
