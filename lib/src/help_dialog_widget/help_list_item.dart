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

  // helper methods
  static List<HelpListItem> itemsFromHelpData({
    required List<HelpData> helpData,
    required bool isMobile,
  }) {
    var index = 0;

    return helpData.map((x) {
      return HelpListItem(
        isMobile: isMobile,
        header: Paragraf(isMobile: isMobile, specs: [x.title]),
        expanded: Paragraf(isMobile: isMobile, specs: [x.message]),
        key: ValueKey(index++),
        initialExpanded: index == 1,
      );
    }).toList();
  }

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

  Widget _expandIcon() {
    return SizedBox(
      height: widget.isMobile ? 16 : 20,
      width: widget.isMobile ? 16 : 20,
      child: Center(
        child: SizedBox(
          height: widget.isMobile ? 14 : 18,
          width: widget.isMobile ? 12 : 14,
          child: CustomPaint(painter: TrianglePainter(color: context.primary)),
        ),
      ),
    );
  }

  XpandableThemeData _theme(BuildContext context) {
    _expandableTheme ??= XpandableThemeData(
      expandIcon: _expandIcon(),
      animationDuration: const Duration(milliseconds: 300),
      crossFadePoint: 0,
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
