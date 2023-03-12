import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart' as linkify;

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(
    this.text, {
    required this.style,
    this.selectable = false,
    this.linkStyle,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextStyle? linkStyle;
  final bool selectable;

  Future<void> _onOpen(linkify.LinkableElement link) async {
    await Utils.launchUrl(link.url);
  }

  @override
  Widget build(BuildContext context) {
    return LinkedText(
      onOpen: _onOpen,
      selectable: selectable,
      style: style,
      linkStyle: linkStyle,
      text: text,
    );
  }
}

// =========================================================
// copied from flutter_linkify

typedef LTCallback = void Function(linkify.LinkableElement link);

class LinkedText extends StatefulWidget {
  final String text;
  final bool selectable;
  final LTCallback? onOpen;
  final TextStyle style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final bool softWrap;

  const LinkedText({
    required this.text,
    required this.style,
    this.selectable = false,
    this.onOpen,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.softWrap = true,
    super.key,
  });

  @override
  State<LinkedText> createState() => _LinkedTextState();
}

class _LinkedTextState extends State<LinkedText> {
  List<linkify.LinkifyElement> _elements = [];

  @override
  void initState() {
    super.initState();
    _rebuildElements();
  }

  @override
  void didUpdateWidget(covariant LinkedText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _rebuildElements();
    }
  }

  TextSpan _buildTextSpan({
    required TextStyle style,
    required TextStyle linkStyle,
    LTCallback? onOpen,
    bool useMouseRegion = false,
  }) {
    return TextSpan(
      children: _elements.map<InlineSpan>(
        (element) {
          if (element is linkify.LinkableElement) {
            if (useMouseRegion) {
              return _LinkableSpan(
                mouseCursor: SystemMouseCursors.click,
                inlineSpan: TextSpan(
                  text: element.text,
                  style: linkStyle,
                  recognizer: onOpen != null
                      ? (TapGestureRecognizer()..onTap = () => onOpen(element))
                      : null,
                ),
              );
            } else {
              return TextSpan(
                text: element.text,
                style: linkStyle,
                recognizer: onOpen != null
                    ? (TapGestureRecognizer()..onTap = () => onOpen(element))
                    : null,
              );
            }
          } else {
            return TextSpan(
              text: element.text,
              style: style,
            );
          }
        },
      ).toList(),
    );
  }

  void _rebuildElements() {
    _elements = linkify.linkify(
      widget.text,
      linkifiers: [...linkify.defaultLinkifiers, const FileLinkifier()],
    );
  }

  @override
  Widget build(BuildContext context) {
    final spans = _buildTextSpan(
      style: widget.style,
      onOpen: widget.onOpen,
      useMouseRegion: !widget.selectable,
      linkStyle: widget.style
          .copyWith(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
          )
          .merge(widget.linkStyle),
    );

    if (widget.selectable) {
      return SelectableText.rich(
        spans,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,

        // SNG if this isn't set and the style is bold for example
        // the TextSpans get clipped? this is a bug in flutter_linkify
        style: widget.style,
      );
    }

    return Text.rich(
      spans,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,

      // SNG if this isn't set and the style is bold for example
      // the TextSpans get clipped? this is a bug in flutter_linkify
      style: widget.style,
    );
  }
}

// =====================================================

class _LinkableSpan extends WidgetSpan {
  _LinkableSpan({
    required MouseCursor mouseCursor,
    required InlineSpan inlineSpan,
  }) : super(
          child: MouseRegion(
            cursor: mouseCursor,
            child: Text.rich(
              inlineSpan,
            ),
          ),
        );
}

// =========================================================

final _urlRegex = RegExp(
  r'^(.*?)((?:file:\/\/)[^\s]*)',
  caseSensitive: false,
  dotAll: true,
);

class FileLinkifier extends linkify.Linkifier {
  const FileLinkifier();

  @override
  List<linkify.LinkifyElement> parse(
    List<linkify.LinkifyElement> elements,
    linkify.LinkifyOptions options,
  ) {
    final list = <linkify.LinkifyElement>[];

    try {
      for (final element in elements) {
        if (element is linkify.TextElement) {
          final match = _urlRegex.firstMatch(element.text);

          if (match == null) {
            list.add(element);
          } else {
            final text = element.text.replaceFirst(match.group(0)!, '');

            final one = match.group(1) ?? '';
            if (one.isNotEmpty) {
              list.add(linkify.TextElement(one));
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
                list.add(linkify.TextElement(end));
              }
            }

            if (text.isNotEmpty) {
              list.addAll(parse([linkify.TextElement(text)], options));
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

/// Represents an element containing a link

/// Represents an element containing an email address
class FileElement extends linkify.LinkableElement {
  FileElement(String url, [String? text]) : super(text, url);

  @override
  String toString() {
    return "FileElement: '$url' ($text)";
  }

  @override
  bool operator ==(dynamic other) => equals(other);

  @override
  bool equals(dynamic other) => other is FileElement && super.equals(other);

  @override
  int get hashCode => Object.hash(url, text);
}
