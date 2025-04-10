import 'package:dfc_flutter/src/widgets/paragraf.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

enum SeoTextType { lgb, lg, md, elg, elgb, hdrb, sm }

class SeoText extends StatelessWidget {
  const SeoText(
    this.text, {
    required this.isMobile,
    required this.type,
    super.key,
    this.textAlign = TextAlign.start,
    this.opacity = 1,
    this.color = ParagrafColor.none,
  });

  final bool isMobile;
  final String text;
  final TextAlign textAlign;
  final double opacity;
  final SeoTextType type;
  final ParagrafColor color;

  @override
  Widget build(BuildContext context) {
    Widget child;
    TextTagStyle tagStyle = TextTagStyle.p;

    switch (type) {
      case SeoTextType.lgb:
        tagStyle = TextTagStyle.h3;
        child = Paragraf.lgb(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.md:
        child = Paragraf.md(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.elg:
        tagStyle = TextTagStyle.h2;
        child = Paragraf.elg(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.elgb:
        tagStyle = TextTagStyle.h2;
        child = Paragraf.elgb(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.hdrb:
        tagStyle = TextTagStyle.h1;
        child = Paragraf.hdrb(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.sm:
        child = Paragraf.sm(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
      case SeoTextType.lg:
        tagStyle = TextTagStyle.h2;
        child = Paragraf.lg(
          text,
          isMobile: isMobile,
          textAlign: textAlign,
          opacity: opacity,
          color: color,
        );
        break;
    }

    return Seo.text(text: text, style: tagStyle, child: child);
  }
}
