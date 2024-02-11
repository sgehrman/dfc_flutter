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

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: fontSize,
      color: color,
    );

    final padding = EdgeInsets.only(bottom: bottomPadding);

    // alignment broken in MarkdownBody, Markdown scrolls
    return Markdown(
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
        blockquoteAlign: textAlign,
        textScaleFactor: textScaleFactor,
        a: textStyle.copyWith(
          decorationColor: Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColor,
        ),
        p: textStyle,
        h1Padding: padding,
        h2Padding: padding,
        h3Padding: padding,
        h4Padding: padding,
        h5Padding: padding,
        h6Padding: padding,
        pPadding: padding,
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
