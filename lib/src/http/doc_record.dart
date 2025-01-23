import 'package:dfc_dart/dfc_dart.dart';
import 'package:dfc_flutter/src/http/http_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:html/dom.dart';

class DocRecord {
  DocRecord({
    required this.document,
    required this.title,
    required this.head,
    required this.body,
    required this.links,
    required this.metas,
    required this.error,
  });

  final Document? document;
  final Element? head;
  final Element? body;

  final List<Element> links;
  final List<Element> metas;

  final String error;
  final String title;

  // =======================================================
  // static utils

  static Future<DocRecord> docRecordForUrl(String url) async {
    Document? document;
    String error = '';
    String title = '';
    Element? head;
    Element? body;

    List<Element> links = [];
    List<Element> metas = [];

    try {
      final uri = UriUtils.parseUri(url);

      // file uris crash on get (no host). eg.  file:///home/steve/Downloads/1420410486.svg
      // avoid urls with an extension .png etc.
      if (UriUtils.uriIsHtml(uri)) {
        final htmlString = await HttpUtils.httpGetBodyWithRedirects(uri!);

        if (htmlString.isNotEmpty) {
          document = Document.html(htmlString);

          body = document.body;

          head = document.head;
          if (head != null) {
            links = head.getElementsByTagName('link');
            metas = head.getElementsByTagName('meta');

            // just get one title if multiple (probably never happens, but safe code)
            final els = head.getElementsByTagName('title');
            if (Utils.isNotEmpty(els)) {
              for (final el in els) {
                title = el.text;

                if (Utils.isNotEmpty(title)) {
                  break;
                }
              }
            }
          }
        }
      }
    } catch (err) {
      error = err.toString();
      // google urls for search fail. I assume google is blocking scrapers
      print('### Error scrapeUrl err: $err url: $url');
    }

    return DocRecord(
      document: document,
      body: body,
      title: title,
      error: error,
      head: head,
      links: links,
      metas: metas,
    );
  }
}
