import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
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
    // bodyMedium since bodyLarge might be bold
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize,
        );

    final aStyle = textStyle.copyWith(
      decorationColor: Theme.of(context).primaryColor,
      color: Theme.of(context).primaryColor,
    );

    final boldStyle = textStyle.copyWith(
      fontWeight: Font.bold,
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
        h1: Theme.of(context).textTheme.displayLarge,
        h2: Theme.of(context).textTheme.displayMedium,
        h3: Theme.of(context).textTheme.displaySmall,
        h4: Theme.of(context).textTheme.headlineMedium,
        h5: Theme.of(context).textTheme.headlineSmall,
      ),
      data: text!,
    );
  }
}
