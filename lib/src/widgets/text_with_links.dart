import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linkify/linkify.dart' as linkify;

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(
    this.text, {
    this.selectable = false,
    this.style,
    this.linkStyle,
    super.key,
  });

  final String text;
  final TextStyle? style;
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
  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final bool softWrap;

  const LinkedText({
    required this.text,
    this.selectable = false,
    this.onOpen,
    this.style,
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
    TextStyle? style,
    TextStyle? linkStyle,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        Theme.of(context).textTheme.bodyMedium ?? const TextStyle();

    final spans = _buildTextSpan(
      style: baseStyle.merge(widget.style),
      onOpen: widget.onOpen,
      useMouseRegion: !widget.selectable,
      linkStyle: baseStyle
          .merge(widget.style)
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
      );
    }

    return Text.rich(
      spans,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      softWrap: widget.softWrap,
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
