import 'package:dfc_flutter/src/widgets/paragraf.dart';

class HelpData {
  const HelpData({
    required this.title,
    required this.message,
  });

  final ParagrafSpec title;
  final ParagrafSpec message;

  // --------------------------------------
  // static helpers

  static void _writeItem(ParagrafSpec item, StringBuffer buffer) {
    buffer.write(item.text);
    for (final c in item.children) {
      _writeItem(c, buffer);
    }
  }

  static String toHtml(List<HelpData> data) {
    final buffer = StringBuffer();

    buffer.write('<!DOCTYPE html><html><head>');
    buffer.write('<meta charSet="utf-8"/>');
    buffer.write('<title>Deckr Help</title>');
    buffer.write(
      '<meta name="viewport" content="minimum-scale=1, initial-scale=1, width=device-width, shrink-to-fit=no, viewport-fit=cover"/>',
    );
    buffer.write('</head><body style="max-width: 600px">');

    for (final item in data) {
      buffer.write('<h4>');
      _writeItem(item.title, buffer);
      buffer.write('</h4>');

      buffer.write('<p>');
      _writeItem(item.message, buffer);
      buffer.write('</p>');
    }

    buffer.write('</body>');
    buffer.write('</html>');

    return buffer.toString();
  }
}
