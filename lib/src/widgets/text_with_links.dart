import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:linkify_plus/linkify/src/hash_url.dart';
import 'package:linkify_plus/linkify/src/hyperlink.dart';
import 'package:linkify_plus/linkify/src/phone_number.dart';
import 'package:linkify_plus/linkify_plus.dart';

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(
    this.text, {
    required this.style,
    this.humanize = false,
    this.selectable = false,
    this.linkStyle,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextStyle? linkStyle;
  final bool selectable;
  final bool humanize;

  @override
  Widget build(BuildContext context) {
    if (selectable) {
      return SelectableLinkify(
        text: text,
        linkStyle: linkStyle ?? style.copyWith(color: context.primary),
        options: LinkifyOptions(humanize: humanize),
        style: style,
        linkifiers: const [
          HyperLinkifier(),
          UrlLinkifier(),
          EmailLinkifier(),
          HashUrlLinkifier(),
          PhoneNumberLinkifier(),
          FileLinkifier(),
        ],
        onOpen: (link) {
          if (Utils.isNotEmpty(link.url)) {
            Utils.launchUrl(link.url);
          }
        },
      );
    }
    return Linkify(
      text: text,
      linkStyle: linkStyle ?? style.copyWith(color: context.primary),
      options: LinkifyOptions(humanize: humanize),
      style: style,
      linkifiers: const [
        HyperLinkifier(),
        UrlLinkifier(),
        EmailLinkifier(),
        HashUrlLinkifier(),
        PhoneNumberLinkifier(),
        FileLinkifier(),
      ],
      onOpen: (link) {
        if (Utils.isNotEmpty(link.url)) {
          Utils.launchUrl(link.url);
        }
      },
    );
  }
}

// =========================================================
// linkify_plus doesn't handle file urls, had to add this

final _urlRegex = RegExp(
  r'^(.*?)((?:file:\/\/)[^\s]*)',
  caseSensitive: false,
  dotAll: true,
);

class FileLinkifier extends Linkifier {
  const FileLinkifier();

  @override
  List<LinkifyElement> parse(
    List<LinkifyElement> elements,
    LinkifyOptions options,
  ) {
    final list = <LinkifyElement>[];

    try {
      for (final element in elements) {
        if (element is TextElement) {
          final match = _urlRegex.firstMatch(element.text);

          if (match == null) {
            list.add(element);
          } else {
            final text = element.text.replaceFirst(match.group(0)!, '');

            final one = match.group(1) ?? '';
            if (one.isNotEmpty) {
              list.add(TextElement(one));
            }

            final two = match.group(2) ?? '';
            if (two.isNotEmpty) {
              var originalUrl = two;
              String? end;

              if ((options.excludeLastPeriod) &&
                  originalUrl[originalUrl.length - 1] == '.') {
                end = '.';
                originalUrl = originalUrl.substring(0, originalUrl.length - 1);
              }

              var url = originalUrl;

              if ((options.humanize) || (options.removeWww)) {
                if (options.humanize) {
                  url = url.replaceFirst(RegExp('file://'), '');
                }

                list.add(
                  FileElement(
                    originalUrl,
                    url,
                  ),
                );
              } else {
                list.add(FileElement(originalUrl));
              }

              if (end != null) {
                list.add(TextElement(end));
              }
            }

            if (text.isNotEmpty) {
              list.addAll(parse([TextElement(text)], options));
            }
          }
        } else {
          list.add(element);
        }
      }
    } catch (err) {
      print('FileLinkifier failed: $err');
    }

    return list;
  }
}

// ================================================================

class FileElement extends LinkableElement {
  FileElement(String url, [String? text]) : super(text, url);

  @override
  String toString() {
    return "FileElement: '$url' ($text)";
  }

  @override
  bool operator ==(Object other) => equals(other);

  @override
  bool equals(dynamic other) => other is FileElement && super.equals(other);

  @override
  int get hashCode => Object.hash(url, text);
}
