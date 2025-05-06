import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:dfc_flutter/src/widgets/linkify_text/regex.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ===========================================================
// NOTE: copied from https://github.com/Iamstanlee/linkfy_text
// needed file:// url support

enum LinkType { url, email, hashTag, userTag, phone, file }

class Link {
  /// construct link from matched regExp
  Link.fromMatch(RegExpMatch match) {
    final m = match.input.substring(match.start, match.end);
    _type = getMatchedType(m);
    _value = m;
  }

  late final String? _value;
  late final LinkType? _type;
  String? get value => _value;
  LinkType? get type => _type;
}

// ===========================================================

class LinkifyText extends StatelessWidget {
  const LinkifyText(
    this.text, {
    this.textStyle,
    this.linkStyle,
    this.linkTypes,
    this.onTap,
    this.customLinkStyles,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    super.key,
  });

  final String text;

  final TextStyle? textStyle;

  final TextStyle? linkStyle;

  final void Function(Link)? onTap;

  final List<LinkType>? linkTypes;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final TextScaler? textScaler;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final Map<LinkType, TextStyle>? customLinkStyles;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      _linkify(
        text: text,
        linkStyle: linkStyle,
        onTap: onTap,
        linkTypes: linkTypes,
        customLinkStyles: customLinkStyles,
      ),
      key: key,
      style: textStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      textWidthBasis: textWidthBasis,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
    );
  }
}

class LinkifySelectableText extends StatelessWidget {
  const LinkifySelectableText(
    this.text, {
    super.key,
    this.focusNode,
    this.textStyle,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.autofocus = false,
    this.minLines,
    this.maxLines,
    this.showCursor = false,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onTap,
    this.scrollPhysics,
    this.semanticsLabel,
    this.textHeightBehavior,
    this.textWidthBasis,
    this.onSelectionChanged,
    this.customLinkStyles,
    this.linkStyle,
    this.linkTypes,
    this.contextMenuBuilder,
  });

  final String text;

  final FocusNode? focusNode;

  final TextStyle? textStyle;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final TextScaler? textScaler;

  final bool autofocus;

  final int? minLines;

  final int? maxLines;

  final bool showCursor;

  final double cursorWidth;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final Color? cursorColor;

  final ui.BoxHeightStyle selectionHeightStyle;

  final ui.BoxWidthStyle selectionWidthStyle;

  final bool enableInteractiveSelection;

  final TextSelectionControls? selectionControls;

  final DragStartBehavior dragStartBehavior;

  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;

  bool get selectionEnabled => enableInteractiveSelection;

  final ScrollPhysics? scrollPhysics;

  final String? semanticsLabel;

  final TextHeightBehavior? textHeightBehavior;

  final TextWidthBasis? textWidthBasis;

  final SelectionChangedCallback? onSelectionChanged;

  final Map<LinkType, TextStyle>? customLinkStyles;

  final TextStyle? linkStyle;

  final void Function(Link)? onTap;

  final List<LinkType>? linkTypes;

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      _linkify(
        text: text,
        linkStyle: linkStyle,
        onTap: onTap,
        linkTypes: linkTypes,
        customLinkStyles: customLinkStyles,
      ),
      key: key,
      focusNode: focusNode,
      style: textStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      showCursor: showCursor,
      autofocus: autofocus,
      contextMenuBuilder: contextMenuBuilder,
      minLines: minLines,
      maxLines: maxLines,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      dragStartBehavior: dragStartBehavior,
      enableInteractiveSelection: enableInteractiveSelection,
      selectionControls: selectionControls,
      scrollPhysics: scrollPhysics,
      semanticsLabel: semanticsLabel,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      onSelectionChanged: onSelectionChanged,
    );
  }
}

TextSpan _linkify({
  String text = '',
  TextStyle? linkStyle,
  List<LinkType>? linkTypes,
  Map<LinkType, TextStyle>? customLinkStyles,
  Function(Link)? onTap,
}) {
  final regExp = constructRegExpFromLinkType(linkTypes ?? [LinkType.url]);

  if (!regExp.hasMatch(text) || text.isEmpty) {
    return TextSpan(text: text);
  }

  final texts = text.split(regExp);
  final spans = <InlineSpan>[];
  final links = regExp.allMatches(text).toList();

  for (final text in texts) {
    spans.add(TextSpan(text: text));
    if (links.isNotEmpty) {
      final match = links.removeAt(0);
      final link = Link.fromMatch(match);

      spans.add(
        TextSpan(
          text: link.value,
          style: customLinkStyles?[link.type] ?? linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (onTap != null) {
                onTap(link);
              }
            },
        ),
      );
    }
  }

  return TextSpan(children: spans);
}
