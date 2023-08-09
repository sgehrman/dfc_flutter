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
      // this doesn't seem to work, don't have a solution
      // problem is pointer events like the scrollwheel are captured by the tooltip
      child: IgnorePointer(
        child: _ToolTipContent(
          message: message ?? '',
          maxWidth: 600,
        ),
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
    final msg = widget.message;

    // rss feed descriptions can be html, convert to markdown
    final markdown = html2md.convert(msg);

    Widget tooltipBody;

    final textStyle = TextStyle(
      fontSize: kFontSize.s,
      color: Utils.isDarkMode(context) ? Colors.black : Colors.white,
      decoration: TextDecoration.none,
    );

    // no change: not html, normal text
    if (msg == markdown) {
      tooltipBody = Text(
        msg,
        softWrap: true,
        style: textStyle,
      );
    } else {
      final markdownStyleSheet = MarkdownStyleSheet(
        a: textStyle,
        img: textStyle,
        p: textStyle,
        h1: textStyle,
        checkbox: textStyle,
        del: textStyle,
        em: textStyle,
        h2: textStyle,
        h3: textStyle,
        h4: textStyle,
        h5: textStyle,
        h6: textStyle,
        listBullet: textStyle,
        tableHead: textStyle,
        strong: textStyle,
        code: textStyle,
        blockquote: textStyle,
        tableBody: textStyle,
        pPadding: EdgeInsets.zero,
        h1Padding: EdgeInsets.zero,
        h2Padding: EdgeInsets.zero,
        h3Padding: EdgeInsets.zero,
        h4Padding: EdgeInsets.zero,
        h5Padding: EdgeInsets.zero,
        h6Padding: EdgeInsets.zero,
        codeblockPadding: EdgeInsets.zero,
        blockquotePadding: EdgeInsets.zero,
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

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 800, maxWidth: widget.maxWidth),
      child: tooltipBody,
    );
  }
}
