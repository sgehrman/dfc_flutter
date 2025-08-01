import 'dart:async';

import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum HoverState { entered, exited }

class HoverOverlay extends StatefulWidget {
  const HoverOverlay({required this.builder});

  final Widget Function(HoverState state) builder;

  @override
  State<HoverOverlay> createState() => _HoverBoxState();
}

class _HoverBoxState extends State<HoverOverlay> {
  HoverState _hoverState = HoverState.exited;
  HoverState _newHoverState = HoverState.exited;
  Timer? _timer;

  @override
  void dispose() {
    _cancelTimer();

    super.dispose();
  }

  void _handleHoverState(HoverState state) {
    _newHoverState = state;
    _newTimer();
  }

  void _newTimer() {
    _cancelTimer();

    _timer = Timer(const Duration(milliseconds: 50), () {
      if (mounted) {
        if (_newHoverState != _hoverState) {
          _hoverState = _newHoverState;

          setState(() => {});
        }
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(_hoverState),
        Positioned.fill(
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.deferToChild,
            onEnter: (e) => _handleHoverState(HoverState.entered),
            onExit: (e) => _handleHoverState(HoverState.exited),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

// =========================================================

// not used currently, but saving for later
// used for showing a close button on hover for example

class HoverOverlayTrigger extends StatefulWidget {
  const HoverOverlayTrigger({
    required this.builder,
    this.onHoverOver,
    this.onHoverTrigger,
    this.child,
  });

  final Widget Function(HoverState state) builder;
  final void Function(HoverState state)? onHoverOver;
  final void Function()? onHoverTrigger;
  final Widget? child;

  @override
  State<HoverOverlayTrigger> createState() => _HoverBoxTriggerState();
}

class _HoverBoxTriggerState extends State<HoverOverlayTrigger> {
  HoverState _hoverState = HoverState.exited;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    _cancelTimer();

    if (_hoverState == HoverState.exited) {
      _hoverState = HoverState.entered;
      _handleHoverChange();
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    _cancelTimer();

    if (_hoverState == HoverState.entered) {
      _hoverState = HoverState.exited;
      _handleHoverChange();
    }
  }

  void _handleHoverChange() {
    if (mounted) {
      widget.onHoverOver?.call(_hoverState);

      setState(() => {});
    }
  }

  void _newTimer() {
    if (widget.onHoverTrigger != null) {
      _cancelTimer();

      _timer = Timer(const Duration(milliseconds: 20), () {
        widget.onHoverTrigger?.call();
      });
    }
  }

  void _cancelTimer() {
    if (widget.onHoverTrigger != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child ?? const NothingWidget(),
        widget.builder(_hoverState),
        Positioned.fill(
          child: MouseRegion(
            opaque: false,
            hitTestBehavior: HitTestBehavior.deferToChild,
            onEnter: _handleMouseEnter,
            onExit: _handleMouseExit,
            onHover: (event) {
              _newTimer();
            },
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
