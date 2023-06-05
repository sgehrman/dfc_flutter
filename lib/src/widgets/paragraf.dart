import 'dart:ui' as ui;

import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class Paragraf extends StatelessWidget {
  const Paragraf({
    required this.specs,
    required this.isMobile,
    this.textAlign = TextAlign.left,
  });

  // ----------------------------------------------
  // simple for just normal strings

  Paragraf.sm(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.sm(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.smb(
    String text, {
    required this.isMobile,
    ParagrafColor color = ParagrafColor.none,
    this.textAlign = TextAlign.left,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.smb(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.lg(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.lg(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.lgb(
    String text, {
    required this.isMobile,
    ParagrafColor color = ParagrafColor.none,
    this.textAlign = TextAlign.left,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.lgb(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.elg(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.elg(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.elgb(
    String text, {
    required this.isMobile,
    ParagrafColor color = ParagrafColor.none,
    this.textAlign = TextAlign.left,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.elgb(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.hdr(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.hdr(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.hdrb(
    String text, {
    required this.isMobile,
    ParagrafColor color = ParagrafColor.none,
    this.textAlign = TextAlign.left,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.hdrb(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.md(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.md(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  Paragraf.mdb(
    String text, {
    required this.isMobile,
    this.textAlign = TextAlign.left,
    ParagrafColor color = ParagrafColor.none,
    double opacity = 1,
  }) : specs = [
          ParagrafSpec.mdb(
            text,
            color: color,
            opacity: opacity,
          ),
        ];

  // ----------------------------------------------

  final List<ParagrafSpec> specs;
  final bool isMobile;
  final TextAlign textAlign;

  static InlineSpan _generate({
    required BuildContext context,
    required ParagrafSpec spec,
    required bool isMobile,
  }) {
    final textStyle = TextStyle(
      color: spec.color.color(context: context, opacity: spec.opacity),
      fontWeight: spec.bold ? ParagrafSizes.defaults.bold : FontWeight.normal,
      fontSize: spec.fontSize.fontSize(isMobile: isMobile),
    );

    String nls = '';
    if (spec.newlines > 0) {
      nls = List.generate(spec.newlines, (index) => '\n').join();
    }

    if (spec.href.isNotEmpty) {
      return TextSpan(
        children: [
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: ui.PlaceholderAlignment.baseline,
            child: InkWell(
              onTap: () {
                Utils.launchUrl(spec.href);
              },
              child: Text(spec.text, style: textStyle),
            ),
          ),
          if (nls.isNotEmpty)
            TextSpan(
              text: nls,
            ),
        ],
      );
    }

    return TextSpan(
      text: '${spec.text}$nls',
      style: textStyle,
      children: spec.children
          .map(
            (e) => _generate(
              context: context,
              spec: e,
              isMobile: isMobile,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (specs.isEmpty) {
      return const NothingWidget();
    }

    if (specs.length == 1) {
      return Text.rich(
        _generate(
          context: context,
          spec: specs.first,
          isMobile: isMobile,
        ),
        textAlign: textAlign,
      );
    }

    final List<Widget> children = specs
        .map(
          (e) => Text.rich(
            _generate(
              context: context,
              spec: e,
              isMobile: isMobile,
            ),
            textAlign: textAlign,
          ),
        )
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// ================================================
// shorthand font size helpers

double sm({required bool isMobile}) =>
    ParagrafSize.sm.fontSize(isMobile: isMobile);
double md({required bool isMobile}) =>
    ParagrafSize.md.fontSize(isMobile: isMobile);
double lg({required bool isMobile}) =>
    ParagrafSize.lg.fontSize(isMobile: isMobile);
double elg({required bool isMobile}) =>
    ParagrafSize.elg.fontSize(isMobile: isMobile);
double hdr({required bool isMobile}) =>
    ParagrafSize.hdr.fontSize(isMobile: isMobile);

// ================================================

class ParagrafSizes {
  ParagrafSizes({
    required this.smFontSize,
    required this.smFontSizeMobile,
    required this.mdFontSize,
    required this.mdFontSizeMobile,
    required this.lgFontSize,
    required this.lgFontSizeMobile,
    required this.elgFontSize,
    required this.elgFontSizeMobile,
    required this.hdrFontSize,
    required this.hdrFontSizeMobile,
    required this.bold,
  });

  ParagrafSizes.defaultValues()
      : smFontSize = 18,
        smFontSizeMobile = 16,
        mdFontSize = 20,
        mdFontSizeMobile = 18,
        lgFontSize = 26,
        lgFontSizeMobile = 22,
        elgFontSize = 32,
        elgFontSizeMobile = 26,
        hdrFontSize = 42,
        hdrFontSizeMobile = 32,
        bold = FontWeight.w600;

  double smFontSize;
  double smFontSizeMobile;

  double mdFontSize;
  double mdFontSizeMobile;

  double lgFontSize;
  double lgFontSizeMobile;

  double elgFontSize;
  double elgFontSizeMobile;

  double hdrFontSize;
  double hdrFontSizeMobile;
  FontWeight bold;

  // call this if you want to change defaults
  static ParagrafSizes defaults = ParagrafSizes.defaultValues();
}

// ================================================

enum ParagrafSize {
  sm,
  md,
  lg,
  elg,
  hdr;

  double fontSize({required bool isMobile}) {
    switch (this) {
      case ParagrafSize.sm:
        return isMobile
            ? ParagrafSizes.defaults.smFontSizeMobile
            : ParagrafSizes.defaults.smFontSize;
      case ParagrafSize.md:
        return isMobile
            ? ParagrafSizes.defaults.mdFontSizeMobile
            : ParagrafSizes.defaults.mdFontSize;
      case ParagrafSize.lg:
        return isMobile
            ? ParagrafSizes.defaults.lgFontSizeMobile
            : ParagrafSizes.defaults.lgFontSize;
      case ParagrafSize.elg:
        return isMobile
            ? ParagrafSizes.defaults.elgFontSizeMobile
            : ParagrafSizes.defaults.elgFontSize;
      case ParagrafSize.hdr:
        return isMobile
            ? ParagrafSizes.defaults.hdrFontSizeMobile
            : ParagrafSizes.defaults.hdrFontSize;
    }
  }
}

// ================================================

enum ParagrafColor {
  none,
  white,
  black,
  primary;

  Color? color({
    required BuildContext context,
    required double opacity,
  }) {
    switch (this) {
      case ParagrafColor.none:
        return Theme.of(context)
            .textTheme
            .bodyMedium!
            .color!
            .withOpacity(opacity);
      case ParagrafColor.black:
        return Colors.black.withOpacity(opacity);
      case ParagrafColor.white:
        return Colors.white.withOpacity(opacity);
      case ParagrafColor.primary:
        return Theme.of(context).primaryColor.withOpacity(opacity);
    }
  }
}

class ParagrafSpec {
  // const ParagrafSpec(
  //   this.text, {
  //   this.bold = false,
  //   this.fontSize = ParagrafSize.md,
  //   this.children = const [],
  //   this.color,
  //   this.newlines = 0,
  //   this.href = '',
  // });

  const ParagrafSpec.link(
    this.text, {
    required this.href,
    this.bold = true,
    this.fontSize = ParagrafSize.md,
    this.children = const [],
    this.color = ParagrafColor.primary,
    this.newlines = 0,
    this.opacity = 1,
  });

  const ParagrafSpec.lg(
    this.text, {
    this.bold = false,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : fontSize = ParagrafSize.lg;

  const ParagrafSpec.lgb(
    this.text, {
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  })  : fontSize = ParagrafSize.lg,
        bold = true;

  const ParagrafSpec.elg(
    this.text, {
    this.bold = false,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : fontSize = ParagrafSize.elg;

  const ParagrafSpec.elgb(
    this.text, {
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  })  : fontSize = ParagrafSize.elg,
        bold = true;

  const ParagrafSpec.hdr(
    this.text, {
    this.bold = false,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : fontSize = ParagrafSize.hdr;

  const ParagrafSpec.hdrb(
    this.text, {
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  })  : fontSize = ParagrafSize.hdr,
        bold = true;

  const ParagrafSpec.md(
    this.text, {
    this.bold = false,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : fontSize = ParagrafSize.md;

  const ParagrafSpec.mdb(
    this.text, {
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  })  : fontSize = ParagrafSize.md,
        bold = true;

  const ParagrafSpec.sm(
    this.text, {
    this.bold = false,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : fontSize = ParagrafSize.sm;

  const ParagrafSpec.smb(
    this.text, {
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  })  : fontSize = ParagrafSize.sm,
        bold = true;

  const ParagrafSpec.bold(
    this.text, {
    this.fontSize = ParagrafSize.md,
    this.children = const [],
    this.color = ParagrafColor.none,
    this.newlines = 0,
    this.href = '',
    this.opacity = 1,
  }) : bold = true;

  final String text;
  final String href;
  final bool bold;
  final ParagrafSize fontSize;
  final int newlines;
  final ParagrafColor color;
  final List<ParagrafSpec> children;
  final double opacity;
}
