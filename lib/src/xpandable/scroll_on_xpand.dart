import 'package:dfc_flutter/src/xpandable/xpandable_controller.dart';
import 'package:dfc_flutter/src/xpandable/xpandable_theme.dart';
import 'package:flutter/material.dart';

class ScrollOnXpand extends StatefulWidget {
  const ScrollOnXpand({
    required this.child,
    required this.theme,
    super.key,
    this.scrollOnExpand = true,
    this.scrollOnCollapse = true,
  });

  final Widget child;
  final bool scrollOnExpand;
  final bool scrollOnCollapse;

  final XpandableThemeData theme;

  @override
  State<ScrollOnXpand> createState() => _ScrollOnXpandState();
}

class _ScrollOnXpandState extends State<ScrollOnXpand> {
  XpandableController? _controller;
  int _isAnimating = 0;
  BuildContext? _lastContext;
  late XpandableThemeData _theme;

  @override
  void initState() {
    super.initState();

    _theme = XpandableThemeData.withDefaults(widget.theme);

    _controller = XpandableController.of(context, rebuildOnChange: false);
    _controller!.addListener(_expandedStateChanged);
  }

  @override
  void didUpdateWidget(ScrollOnXpand oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newController =
        XpandableController.of(context, rebuildOnChange: false);
    if (newController != _controller) {
      _controller!.removeListener(_expandedStateChanged);
      _controller = newController;
      _controller!.addListener(_expandedStateChanged);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_expandedStateChanged);
  }

  void _animationComplete() {
    _isAnimating--;
    if (_isAnimating == 0 && _lastContext != null && mounted) {
      if ((_controller!.expanded && widget.scrollOnExpand) ||
          (!_controller!.expanded && widget.scrollOnCollapse)) {
        _lastContext
            ?.findRenderObject()
            ?.showOnScreen(duration: _theme.scrollAnimationDuration!);
      }
    }
  }

  void _expandedStateChanged() {
    _isAnimating++;
    Future.delayed(
      _theme.scrollAnimationDuration! + const Duration(milliseconds: 10),
      _animationComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    _lastContext = context;

    return widget.child;
  }
}
