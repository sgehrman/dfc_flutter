import 'dart:math' as math;

import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class HelpListItem extends StatefulWidget {
  const HelpListItem({
    required Key key,
    required this.header,
    required this.expanded,
    required this.isMobile,
    this.initialExpanded = false,
  }) : super(key: key);

  final Widget header;
  final Widget expanded;
  final bool initialExpanded;
  final bool isMobile;

  @override
  State<HelpListItem> createState() => _HelpListItemState();
}

class _HelpListItemState extends State<HelpListItem> {
  XpandableController? _controller;
  XpandableThemeData? _expandableTheme;

  @override
  void initState() {
    super.initState();

    _controller = XpandableController(initialExpanded: widget.initialExpanded);
  }

  Widget _expandIcon({required bool downArrow}) {
    return SizedBox(
      height: widget.isMobile ? 16 : 20,
      width: widget.isMobile ? 16 : 20,
      child: Center(
        child: SizedBox(
          height: widget.isMobile ? 14 : 18,
          width: widget.isMobile ? 12 : 14,
          child: CustomPaint(
            painter: TrianglePainter(
              color: context.primary,
            ),
          ),
        ),
      ),
    );
  }

  XpandableThemeData _theme(BuildContext context) {
    _expandableTheme ??= XpandableThemeData(
      collapseIcon: _expandIcon(downArrow: true),
      expandIcon: _expandIcon(downArrow: false),
      iconRotationAngle: math.pi / 2,
      animationDuration: const Duration(milliseconds: 300),
      crossFadePoint: 0,
      hoverColor: Utils.isDarkMode(context)
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.05),
      headerDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );

    return _expandableTheme!;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: XpandableNotifier(
        controller: _controller,
        child: ScrollOnXpand(
          theme: theme,
          child: XpandablePanel(
            isMobile: widget.isMobile,
            theme: theme,
            header: widget.header,
            expanded: widget.expanded,
            builder: (_, expanded) {
              return Xpandable(
                expanded: Padding(
                  padding: EdgeInsets.only(
                    top: widget.isMobile ? 8 : 10,
                    left: widget.isMobile ? 40 : 48,
                    bottom: widget.isMobile ? 14 : 16,
                  ),
                  child: expanded,
                ),
                theme: theme,
              );
            },
          ),
        ),
      ),
    );
  }
}
