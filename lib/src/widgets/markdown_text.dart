import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.markdownText, {
    this.fontSize = 16,
    this.color,
    this.onTapLink,
    this.textAlign = WrapAlignment.start,
    this.softLineBreak = false,
    this.blockSpacing = 4.0,
  });

  final String markdownText;
  final double fontSize;
  final bool softLineBreak;
  final void Function(String text, String? href, String title)? onTapLink;
  final WrapAlignment textAlign;
  final Color? color;
  final double blockSpacing;

  @override
  Widget build(BuildContext context) {
    // bodyMedium since bodyLarge might be bold
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: fontSize,
          color: color,
        );

    final aStyle = textStyle.copyWith(
      decorationColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.primary,
    );

    final boldStyle = textStyle.copyWith(
      fontWeight: Font.bold,
    );

    // was showing white in light mode without this
    final tableBorderColor =
        Theme.of(context).textTheme.displayLarge?.color ?? Colors.red;

    return MarkdownBody(
      onTapLink: onTapLink ??
          (text, href, title) {
            Utils.launchUrl(href!);
          },
      softLineBreak: softLineBreak,
      styleSheet: MarkdownStyleSheet(
        blockSpacing: blockSpacing,
        textAlign: textAlign,
        h1Align: textAlign,
        h2Align: textAlign,
        h3Align: textAlign,
        h4Align: textAlign,
        h5Align: textAlign,
        h6Align: textAlign,
        unorderedListAlign: textAlign,
        orderedListAlign: textAlign,
        blockquoteAlign: textAlign,
        codeblockAlign: textAlign,
        a: aStyle,
        p: textStyle,
        h1Padding: const EdgeInsets.only(bottom: 4),
        h2Padding: const EdgeInsets.only(bottom: 4),
        h3Padding: const EdgeInsets.only(bottom: 4),
        h4Padding: const EdgeInsets.only(bottom: 4),
        h5Padding: const EdgeInsets.only(bottom: 4),
        h6Padding: const EdgeInsets.only(bottom: 4),
        pPadding: const EdgeInsets.only(bottom: 4),
        strong: boldStyle,
        h1: boldStyle.copyWith(fontSize: fontSize * 1.5),
        h2: boldStyle.copyWith(fontSize: fontSize * 1.4),
        h3: boldStyle.copyWith(fontSize: fontSize * 1.3),
        h4: textStyle.copyWith(fontSize: fontSize * 1.2),
        h5: textStyle.copyWith(fontSize: fontSize * 1.1),
        // ## was doing this before, but fonts very large
        // h1: Theme.of(context).textTheme.displayLarge,
        // h2: Theme.of(context).textTheme.displayMedium,
        // h3: Theme.of(context).textTheme.displaySmall,
        // h4: Theme.of(context).textTheme.headlineMedium,
        // h5: Theme.of(context).textTheme.headlineSmall,
        tableBorder: TableBorder(
          top: BorderSide(
            color: tableBorderColor,
          ),
          bottom: BorderSide(
            color: tableBorderColor,
          ),
          left: BorderSide(
            color: tableBorderColor,
          ),
          right: BorderSide(
            color: tableBorderColor,
          ),
        ),
      ),
      data: markdownText,
    );
  }
}
