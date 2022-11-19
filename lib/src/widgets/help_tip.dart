import 'package:dfc_flutter/src/themes/platform_sizes.dart';
import 'package:dfc_flutter/src/utils/preferences.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:just_the_tooltip_fork/just_the_tooltip_fork.dart';

class HelpTip extends StatefulWidget {
  const HelpTip({
    required this.message,
    required this.child,
    this.direction = AxisDirection.down,
    this.maxWidth = 600,
    this.waitDuration,
  });

  final String? message;
  final Widget child;
  final AxisDirection direction;
  final double maxWidth;
  final Duration? waitDuration;

  @override
  State<HelpTip> createState() => _HelpTipState();
}

class _HelpTipState extends State<HelpTip> {
  late Widget _content;

  @override
  void initState() {
    super.initState();

    _updateContent();
  }

  void _updateContent() {
    if (Utils.isEmpty(widget.message)) {
      _content = const NothingWidget();
    } else {
      _content = HelpTipContent(
        message: widget.message!,
        maxWidth: widget.maxWidth,
      );
    }
  }

  @override
  void didUpdateWidget(covariant HelpTip oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.message != widget.message) {
      _updateContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Preferences().disableTooltips || Utils.isEmpty(widget.message)) {
      return widget.child;
    }

    return JustTheTooltip(
      backgroundColor: Colors.black,
      preferredDirection: widget.direction,
      waitDuration: widget.waitDuration ?? const Duration(milliseconds: 1200),
      tailLength: 20,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      fadeInDuration: const Duration(milliseconds: 400),
      fadeOutDuration: const Duration(milliseconds: 400),
      tailBaseWidth: 18,
      content: _content,
      child: widget.child,
    );
  }
}

// ===========================================================

class HelpTipContent extends StatefulWidget {
  const HelpTipContent({
    required this.message,
    required this.maxWidth,
  });

  final String message;
  final double maxWidth;

  @override
  State<HelpTipContent> createState() => _HelpTipContentState();
}

class _HelpTipContentState extends State<HelpTipContent> {
  static final TextStyle style = TextStyle(
    color: Colors.white,
    fontSize: kFontSize.s,
    decoration: TextDecoration.none,
  );

  static const decoration = BoxDecoration(
    color: Colors.white,
  );

  static final markdownStyleSheet = MarkdownStyleSheet(
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
  );

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
          color: Colors.white,
          fontSize: kFontSize.s,
          decoration: TextDecoration.none,
        ),
      );
    } else {
      tooltipBody = MarkdownBody(
        imageBuilder: (uri, title, alt) {
          return const SizedBox();
        },
        softLineBreak: true,
        styleSheet: markdownStyleSheet,
        data: markdown,
      );
    }

    // StrUtils.print(markdown);

    return Container(
      constraints: BoxConstraints(maxHeight: 800, maxWidth: widget.maxWidth),
      padding: const EdgeInsets.all(12),
      child: tooltipBody,
    );
  }
}
