import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;

// same as Tooltip, but handles null messages without exceptions
// it also wraps text so the tooltip isn't so wide

class DFTooltip extends StatelessWidget {
  const DFTooltip({
    required this.message,
    required this.child,
    this.preferBelow,
  });

  final String? message;
  final Widget child;
  final bool? preferBelow;

  List<String> _breakWord(String input, int maxLength) {
    final segments = <String>[];
    var start = 0;

    while (start < input.length) {
      final end =
          (start + maxLength > input.length) ? input.length : start + maxLength;

      segments.add(input.substring(start, end));
      start = end;
    }

    return segments;
  }

  List<String> _words(String text, int maxLength) {
    final result = <String>[];

    final words = text.split(' ');

    for (final word in words) {
      if (word.length > maxLength) {
        // must be a url or something without spaces, break up words
        result.addAll(_breakWord(word, maxLength ~/ 4));
        result.add(' ');
      } else {
        result.add('$word ');
      }
    }

    return result;
  }

  String _wrapString(String? message, int maxLength) {
    if (message != null && message.isNotEmpty) {
      final buffer = StringBuffer();

      final lines = message.split('\n');
      for (final line in lines) {
        final words = _words(line, maxLength);

        var letterCnt = 0;
        for (final word in words) {
          letterCnt += word.length;
          buffer.write(word);

          if (letterCnt > maxLength) {
            letterCnt = 0;
            buffer.write('\n');
          }
        }

        buffer.write('\n');
      }

      return buffer.toString().trim();
    }

    return '';
  }

  String _htmlToText(String htmlString) {
    try {
      final document = html_parser.parse(htmlString);

      return document.body?.text ?? htmlString;
    } catch (err) {
      print(err);
    }

    return htmlString;
  }

  @override
  Widget build(BuildContext context) {
    var msg = message ?? '';

    // AI chat models have html tooltips
    if (msg.startsWith('<')) {
      msg = _htmlToText(msg);
    }

    msg = _wrapString(msg, 46);

    if (msg.isNotEmpty) {
      return Tooltip(
        message: msg,
        preferBelow: preferBelow,
        child: child,
      );
    }

    return child;
  }
}
