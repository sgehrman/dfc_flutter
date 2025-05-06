import 'package:dfc_flutter/src/http/doc_record.dart';
import 'package:html/dom.dart';
import 'package:html/html_escape.dart';

class DocumentParser {
  DocumentParser._();

  static Future<String> htmlSource(String url) async {
    try {
      final docRec = await DocRecord.docRecordForUrl(url);
      const marker = '==========';

      if (docRec.document != null) {
        var result = 'Source: $url\n\n';
        result += '$marker\n== HEAD ==\n$marker\n\n';

        result += _documentToString(docRec.head, 0);
        result += '\n$marker\n== BODY ==\n$marker\n\n';
        result += _documentToString(docRec.document?.body, 0);

        return result;
      }
    } catch (err) {
      print('htmlSourceString: $err');
    }

    return '';
  }

  static String _documentToString(Node? node, int level) {
    if (node == null) {
      return '';
    }

    final buffer = StringBuffer();
    var openTag = '';

    final levelSpaces = List.generate(level, (index) => '  ').join();

    var output = '';

    if (node is DocumentFragment) {
      // print('DocumentFragment');
    } else if (node is DocumentType) {
      // print('DocumentType');
    } else if (node is Document) {
      // print('Document');
    } else if (node is Element) {
      if (node.nodes.isNotEmpty) {
        openTag = node.localName ?? 'unknown';

        final str = StringBuffer();

        str.write('<');
        str.write(node.localName);

        if (node.attributes.isNotEmpty) {
          node.attributes.forEach((key, v) {
            str.write(' ');
            str.write(key);
            str.write('="');
            str.write(htmlSerializeEscape(v, attributeMode: true));
            str.write('"');
          });
        }

        str.write('>');

        output = str.toString();
      } else {
        output = node.outerHtml;
      }
    } else if (node is Text) {
      output = node.data;
    } else if (node is Comment) {
      output = node.text ?? '';
    } else {
      print('not handled: ${node.runtimeType}');
    }

    if (output.isNotEmpty) {
      buffer.writeln('$levelSpaces$output');
    }

    for (final node in node.nodes) {
      var childResult = _documentToString(node, level + 1);

      if (childResult.trimRight().isNotEmpty) {
        childResult = childResult.trimRight();
      } else if (childResult.trim().isEmpty) {
        childResult = '';
      }

      if (childResult.isNotEmpty) {
        buffer.writeln(childResult);
      }
    }

    if (openTag.isNotEmpty) {
      buffer.writeln('$levelSpaces</ $openTag>');
    }

    return buffer.toString();
  }
}
