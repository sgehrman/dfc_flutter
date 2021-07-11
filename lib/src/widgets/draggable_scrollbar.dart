import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// code based on https://github.com/fluttercommunity/flutter-draggable-scrollbar
// see their readme for instructions

typedef ScrollThumbBuilder = Widget Function(
  Color backgroundColor,
  Animation<double>? thumbAnimation,
  Animation<double>? labelAnimation, {
  Text? labelText,
});

typedef LabelTextBuilder = Text Function(double offsetY);

const heightScrollThumb = 64.0;
const widthScrollThumb = heightScrollThumb * 0.6;

class DraggableScrollbar extends StatefulWidget {
  DraggableScrollbar({
    Key? key,
    required this.child,
    required this.controller,
    this.backgroundColor = Colors.white,
    this.padding,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 300),
    this.scrollbarTimeToFade = const Duration(milliseconds: 600),
    this.labelTextBuilder,
  })  : assert(child.scrollDirection == Axis.vertical),
        scrollThumbBuilder = _thumbSemicircleBuilder(),
        super(key: key);

  final BoxScrollView child;
  final ScrollThumbBuilder scrollThumbBuilder;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Duration scrollbarAnimationDuration;
  final Duration scrollbarTimeToFade;
  final LabelTextBuilder? labelTextBuilder;
  final ScrollController controller;

  @override
  _DraggableScrollbarState createState() => _DraggableScrollbarState();

  static Widget buildScrollThumbAndLabel({
    required Widget scrollThumb,
    required Animation<double>? thumbAnimation,
    required Animation<double>? labelAnimation,
    required Text? labelText,
  }) {
    final scrollThumbAndLabel = labelText == null
        ? scrollThumb
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ScrollLabel(
                animation: labelAnimation,
                child: labelText,
              ),
              scrollThumb,
            ],
          );

    return SlideFadeTransition(
      animation: thumbAnimation,
      child: scrollThumbAndLabel,
    );
  }

  static ScrollThumbBuilder _thumbSemicircleBuilder() {
    return (
      Color backgroundColor,
      Animation<double>? thumbAnimation,
      Animation<double>? labelAnimation, {
      Text? labelText,
    }) {
      final scrollThumb = Material(
        elevation: 4.0,
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(heightScrollThumb),
          bottomLeft: Radius.circular(heightScrollThumb),
          topRight: Radius.circular(4.0),
          bottomRight: Radius.circular(4.0),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 4),
          constraints: BoxConstraints.loose(
              const Size(widthScrollThumb, heightScrollThumb)),
          child: const Icon(Icons.reorder, color: Colors.white),
        ),
      );

      return buildScrollThumbAndLabel(
        scrollThumb: scrollThumb,
        thumbAnimation: thumbAnimation,
        labelAnimation: labelAnimation,
        labelText: labelText,
      );
    };
  }
}

class ScrollLabel extends StatelessWidget {
  const ScrollLabel({
    required this.child,
    required this.animation,
  });

  final Animation<double>? animation;
  final Text child;

  static BoxConstraints constraints =
      BoxConstraints.loose(const Size(48.0, 48.0));

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation!,
      child: Container(
        margin: const EdgeInsets.only(right: 22.0),
        child: Material(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          child: Container(
            constraints: constraints,
            alignment: Alignment.center,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _DraggableScrollbarState extends State<DraggableScrollbar>
    with TickerProviderStateMixin {
  late double _barOffset;
  late double _viewOffset;
  late bool _isDragInProcess;

  late AnimationController _thumbAnimationController;
  Animation<double>? _thumbAnimation;
  late AnimationController _labelAnimationController;
  Animation<double>? _labelAnimation;
  Timer? _fadeoutTimer;

  @override
  void initState() {
    super.initState();
    _barOffset = 0.0;
    _viewOffset = 0.0;
    _isDragInProcess = false;

    _thumbAnimationController = AnimationController(
      vsync: this,
      duration: widget.scrollbarAnimationDuration,
    );

    _thumbAnimation = CurvedAnimation(
      parent: _thumbAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    _labelAnimationController = AnimationController(
      vsync: this,
      duration: widget.scrollbarAnimationDuration,
    );

    _labelAnimation = CurvedAnimation(
      parent: _labelAnimationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _thumbAnimationController.dispose();
    _fadeoutTimer?.cancel();
    super.dispose();
  }

  double get barMaxScrollExtent => context.size!.height - heightScrollThumb;
  double get barMinScrollExtent => 0.0;
  double get viewMaxScrollExtent => widget.controller.position.maxScrollExtent;
  double get viewMinScrollExtent => widget.controller.position.minScrollExtent;

  @override
  Widget build(BuildContext context) {
    Text? labelText;

    if (widget.labelTextBuilder != null && _isDragInProcess) {
      labelText = widget.labelTextBuilder!(
        _viewOffset + _barOffset + heightScrollThumb / 2,
      );
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          changePosition(notification);

          // false allows other listeners to get notifications
          return false;
        },
        child: Stack(
          children: <Widget>[
            RepaintBoundary(
              child: widget.child,
            ),
            RepaintBoundary(
                child: GestureDetector(
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: _barOffset),
                padding: widget.padding,
                child: widget.scrollThumbBuilder(
                  widget.backgroundColor,
                  _thumbAnimation,
                  _labelAnimation,
                  labelText: labelText,
                ),
              ),
            )),
          ],
        ),
      );
    });
  }

  void changePosition(ScrollNotification notification) {
    if (_isDragInProcess) {
      return;
    }

    setState(() {
      if (notification is ScrollUpdateNotification) {
        _barOffset += getBarDelta(
          notification.scrollDelta!,
          barMaxScrollExtent,
          viewMaxScrollExtent,
        );

        if (_barOffset < barMinScrollExtent) {
          _barOffset = barMinScrollExtent;
        }
        if (_barOffset > barMaxScrollExtent) {
          _barOffset = barMaxScrollExtent;
        }

        _viewOffset += notification.scrollDelta!;
        if (_viewOffset < widget.controller.position.minScrollExtent) {
          _viewOffset = widget.controller.position.minScrollExtent;
        }
        if (_viewOffset > viewMaxScrollExtent) {
          _viewOffset = viewMaxScrollExtent;
        }
      }

      if (notification is ScrollUpdateNotification ||
          notification is OverscrollNotification) {
        if (_thumbAnimationController.status != AnimationStatus.forward) {
          _thumbAnimationController.forward();
        }

        _fadeoutTimer?.cancel();
        _fadeoutTimer = Timer(widget.scrollbarTimeToFade, () {
          _thumbAnimationController.reverse();
          _labelAnimationController.reverse();
          _fadeoutTimer = null;
        });
      }
    });
  }

  double getBarDelta(
    double scrollViewDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;
  }

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) {
    return barDelta * viewMaxScrollExtent / barMaxScrollExtent;
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isDragInProcess = true;
      _labelAnimationController.forward();
      _fadeoutTimer?.cancel();
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (_thumbAnimationController.status != AnimationStatus.forward) {
        _thumbAnimationController.forward();
      }
      if (_isDragInProcess) {
        _barOffset += details.delta.dy;

        if (_barOffset < barMinScrollExtent) {
          _barOffset = barMinScrollExtent;
        }
        if (_barOffset > barMaxScrollExtent) {
          _barOffset = barMaxScrollExtent;
        }

        final double viewDelta = getScrollViewDelta(
            details.delta.dy, barMaxScrollExtent, viewMaxScrollExtent);

        _viewOffset = widget.controller.position.pixels + viewDelta;
        if (_viewOffset < widget.controller.position.minScrollExtent) {
          _viewOffset = widget.controller.position.minScrollExtent;
        }
        if (_viewOffset > viewMaxScrollExtent) {
          _viewOffset = viewMaxScrollExtent;
        }
        widget.controller.jumpTo(_viewOffset);
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _fadeoutTimer = Timer(widget.scrollbarTimeToFade, () {
      _thumbAnimationController.reverse();
      _labelAnimationController.reverse();
      _fadeoutTimer = null;
    });
    setState(() {
      _isDragInProcess = false;
    });
  }
}

class SlideFadeTransition extends StatelessWidget {
  const SlideFadeTransition({
    Key? key,
    required this.animation,
    required this.child,
  }) : super(key: key);

  final Animation<double>? animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (context, child) =>
          animation!.value == 0.0 ? Container() : child!,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0.3, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(animation!),
        child: FadeTransition(
          opacity: animation!,
          child: child,
        ),
      ),
    );
  }
}
