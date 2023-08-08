import 'package:dfc_flutter/src/preferences/preferences.dart';
import 'package:dfc_flutter/src/themes/platform_sizes.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

// like Tooltip, but handles html tips
class ToolTip extends StatelessWidget {
  const ToolTip({
    required this.child,
    required this.message,
    this.waitDuration,
    super.key,
  });

  final Widget child;
  final String? message;
  final Duration? waitDuration;

  @override
  Widget build(BuildContext context) {
    if (Preferences().disableTooltips || Utils.isEmpty(message)) {
      return child;
    }

    final WidgetSpan tooltipWidget = WidgetSpan(
      child: _ToolTipContent(
        message: message ?? '',
        maxWidth: 600,
      ),
    );

    return Tooltip(
      richMessage: tooltipWidget,
      waitDuration: waitDuration, // rarely customized, usually null
      child: child,
    );
  }
}

// ===========================================================

class _ToolTipContent extends StatefulWidget {
  const _ToolTipContent({
    required this.message,
    required this.maxWidth,
  });

  final String message;
  final double maxWidth;

  @override
  State<_ToolTipContent> createState() => _ToolTipContentState();
}

class _ToolTipContentState extends State<_ToolTipContent> {
  @override
  Widget build(BuildContext context) {
    final msg = widget.message; // _wrapString();

    // rss feed descriptions can be html, convert to markdown
    final markdown = html2md.convert(msg);

    Widget tooltipBody;

    if (msg == markdown) {
      // markdown was expanded vertically for one line content
      // so we just use a Text
      tooltipBody = Text(
        msg,
        softWrap: true,
        style: TextStyle(
          fontSize: kFontSize.s,
          decoration: TextDecoration.none,
        ),
      );
    } else {
      final TextStyle style = TextStyle(
        fontSize: kFontSize.s,
        color: Utils.isDarkMode(context) ? Colors.black : Colors.white,
        decoration: TextDecoration.none,
      );

      final markdownStyleSheet = MarkdownStyleSheet(
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
        blockquote: style,
        tableBody: style,
      );

      tooltipBody = MarkdownBody(
        imageBuilder: (uri, title, alt) {
          return const SizedBox();
        },
        softLineBreak: true,
        styleSheet: markdownStyleSheet,
        data: markdown,
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 800, maxWidth: widget.maxWidth),
      padding: const EdgeInsets.all(12),
      child: tooltipBody,
    );
  }
}
