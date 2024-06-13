import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomMarkdown extends StatelessWidget {
  const CustomMarkdown(
    this.markdownText, {
    required this.color,
    this.fontSize = 16,
    this.h1FontSize = 42,
    this.h2FontSize = 38,
    this.h3FontSize = 32,
    this.h4FontSize = 28,
    this.h5FontSize = 24,
    this.h6FontSize = 22,
    this.bottomPadding = 4,
    this.blockSpacing = 4,
    this.textScaleFactor = 1,
    this.onTapLink,
    this.textAlign = WrapAlignment.start,
    this.softLineBreak = false,
    this.padding = const EdgeInsets.all(16),
    this.shrinkWrap = false,
    this.fontFamily,
  });

  final String markdownText;
  final Color color;
  final double fontSize;
  final double textScaleFactor;
  final double blockSpacing;
  final double bottomPadding;
  final double h1FontSize;
  final double h2FontSize;
  final double h3FontSize;
  final double h4FontSize;
  final double h5FontSize;
  final double h6FontSize;
  final bool softLineBreak;
  final void Function(String text, String? href, String title)? onTapLink;
  final WrapAlignment textAlign;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: fontSize,
      color: color,
      height: 1,
      decorationColor: color,
      fontFamily: fontFamily,
    );

    final blockPadding = EdgeInsets.only(bottom: bottomPadding);

    // alignment broken in MarkdownBody, Markdown scrolls
    return Markdown(
      shrinkWrap: shrinkWrap,
      padding: padding,
      onTapLink: onTapLink ??
          (text, href, title) {
            Utils.launchUrl(href!);
          },
      softLineBreak: softLineBreak,
      styleSheet: MarkdownStyleSheet(
        code: textStyle,
        blockquote: textStyle,
        blockquotePadding: const EdgeInsets.all(12),
        codeblockPadding: const EdgeInsets.all(12),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: color,
            ),
          ),
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        blockquoteDecoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        listBullet: textStyle,
        blockSpacing: blockSpacing,
        textAlign: textAlign,
        h1Align: textAlign,
        h2Align: textAlign,
        h3Align: textAlign,
        h4Align: textAlign,
        h5Align: textAlign,
        h6Align: textAlign,
        blockquoteAlign: textAlign,
        textScaler: TextScaler.linear(textScaleFactor),
        a: textStyle.copyWith(
          decorationColor: Theme.of(context).colorScheme.primary,
          color: Theme.of(context).colorScheme.primary,
        ),
        p: textStyle,
        h1Padding: blockPadding,
        h2Padding: blockPadding,
        h3Padding: blockPadding,
        h4Padding: blockPadding,
        h5Padding: blockPadding,
        h6Padding: blockPadding,
        pPadding: blockPadding,
        strong: textStyle.copyWith(
          fontWeight: Font.bold,
        ),
        h1: textStyle.copyWith(
          fontSize: h1FontSize,
        ),
        h2: textStyle.copyWith(
          fontSize: h2FontSize,
        ),
        h3: textStyle.copyWith(
          fontSize: h3FontSize,
        ),
        h4: textStyle.copyWith(
          fontSize: h4FontSize,
        ),
        h5: textStyle.copyWith(
          fontSize: h5FontSize,
        ),
        h6: textStyle.copyWith(
          fontSize: h6FontSize,
        ),
        tableBorder: TableBorder(
          top: BorderSide(
            color: color,
          ),
          bottom: BorderSide(
            color: color,
          ),
          left: BorderSide(
            color: color,
          ),
          right: BorderSide(
            color: color,
          ),
        ),
      ),
      data: markdownText,
    );
  }
}
