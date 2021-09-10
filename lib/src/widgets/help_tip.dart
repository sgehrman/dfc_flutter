import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:just_the_tooltip/just_the_tooltip.dart';

class HelpTip extends StatefulWidget {
  const HelpTip({
    required this.message,
    required this.child,
    this.direction = AxisDirection.down,
  });

  final String message;
  final Widget child;
  final AxisDirection direction;

  @override
  State<HelpTip> createState() => _HelpTipState();
}

class _HelpTipState extends State<HelpTip> {
  // String _wrapString(String message) {
  //   final words = message.split(' ');

  //   final buffer = StringBuffer();

  //   int cnt = 0;
  //   for (final word in words) {
  //     cnt += word.length;
  //     buffer.write('$word ');

  //     if (cnt > 40) {
  //       cnt = 0;
  //       buffer.write('\n');
  //     }
  //   }

  //   return buffer.toString().trim();
  // }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message; // _wrapString();

    if (Preferences.disableTooltips || Utils.isEmpty(msg)) {
      return widget.child;
    }

    // rss feed descriptions can be html, convert to markdown
    final markdown = html2md.convert(msg);
    const TextStyle style = TextStyle(
      color: Colors.red,
      fontSize: 18,
      decoration: TextDecoration.none,
    );

    const decoration = BoxDecoration(
      color: Colors.red,
    );

    Widget tooltipBody;

    if (msg == markdown) {
      // markdown was expanded vertically for one line content
      tooltipBody = Text(
        msg,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      );
    } else {
      tooltipBody = MarkdownBody(
        softLineBreak: true,
        styleSheet: MarkdownStyleSheet(
          a: style,
          img: style,
          p: style,
          h1: style,
          checkbox: style,
          del: style,
          em: style,
          h2: style,
          h3: style,
          h4: style,
          h5: style,
          h6: style,
          listBullet: style,
          tableHead: style,
          strong: style,
          code: style,
          horizontalRuleDecoration: decoration,
          codeblockDecoration: decoration,
          blockquoteDecoration: decoration,
          tableCellsDecoration: decoration,
          blockquote: style,
          tableBody: style,
        ),
        data: markdown,
      );

      print(markdown);
    }

    return JustTheTooltip(
      preferredDirection: widget.direction,
      waitDuration: const Duration(milliseconds: 1200),
      tailLength: 20,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      fadeInDuration: const Duration(milliseconds: 400),
      fadeOutDuration: const Duration(milliseconds: 400),
      tailBaseWidth: 18,
      content: Container(
        constraints: const BoxConstraints(maxHeight: 800, maxWidth: 600),
        padding: const EdgeInsets.all(12.0),
        child: tooltipBody,
      ),
      child: widget.child,
    );
  }
}
