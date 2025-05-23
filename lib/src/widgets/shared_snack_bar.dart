import 'dart:async';

import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/widgets/shared_context.dart';
import 'package:dfc_flutter/src/widgets/txt.dart';
import 'package:flutter/material.dart';

class SharedSnackBars {
  factory SharedSnackBars() {
    return _instance ??= SharedSnackBars._();
  }

  SharedSnackBars._() {
    _processStream();
  }

  static SharedSnackBars? _instance;
  final _pending = StreamController<_StandardSnackBar>();

  void show({
    required String title,
    required String message,
    bool error = false,
  }) {
    _pending.add(
      _StandardSnackBar(title: title, message: message, error: error),
    );
  }

  Future<void> _processStream() async {
    await for (final snackbar in _pending.stream) {
      SharedSnackBar._show(snackbar).ignore();

      // this allows multiple shown at once
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}

// ===================================================================

class SharedSnackBar extends StatefulWidget {
  const SharedSnackBar({
    required this.child,
    required this.onDismissed,
    required this.showOutAnimationDuration,
    required this.hideOutAnimationDuration,
    required this.displayDuration,
    required this.additionalTopPadding,
    this.onTap,
    this.onTop = false,
  });

  final Widget child;
  final VoidCallback onDismissed;
  final Duration showOutAnimationDuration;
  final Duration hideOutAnimationDuration;
  final Duration displayDuration;
  final double additionalTopPadding;
  final VoidCallback? onTap;
  final bool onTop;

  static Future<void> _show(
    Widget child, {
    double additionalTopPadding = 16.0,
  }) async {
    final context = SharedContext().scaffoldContext;
    final overlayState = Overlay.of(context);
    final completed = Completer<bool>();

    // this means the keyboard is visible
    final onTop = MediaQuery.of(context).viewInsets.bottom != 0;

    const showOutAnimationDuration = Duration(milliseconds: 1000);
    const hideOutAnimationDuration = Duration(milliseconds: 500);
    const displayDuration = Duration(milliseconds: 1500);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return SharedSnackBar(
          onTop: onTop,
          onDismissed: () {
            completed.complete(true);
          },
          showOutAnimationDuration: showOutAnimationDuration,
          hideOutAnimationDuration: hideOutAnimationDuration,
          displayDuration: displayDuration,
          additionalTopPadding: additionalTopPadding,
          child: child,
        );
      },
    );

    overlayState.insert(overlayEntry);

    await completed.future;
    overlayEntry.remove();
  }

  @override
  State<SharedSnackBar> createState() => _SharedSnackBarState();
}

class _SharedSnackBarState extends State<SharedSnackBar>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> offsetAnimation;
  late AnimationController animationController;
  double? topPosition;

  @override
  void initState() {
    super.initState();

    topPosition = widget.additionalTopPadding;
    _setupAndStartAnimation();
  }

  Future<void> _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.showOutAnimationDuration,
      reverseDuration: widget.hideOutAnimationDuration,
    );

    final offsetTween = Tween<Offset>(
      begin: Offset(0, widget.onTop ? -1.0 : 1.0),
      end: Offset.zero,
    );

    offsetAnimation = offsetTween.animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticOut,
        reverseCurve: Curves.linearToEaseOut,
      ),
    );

    offsetAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future<dynamic>.delayed(widget.displayDuration);

        await animationController.reverse();
      }

      if (status == AnimationStatus.dismissed) {
        widget.onDismissed.call();
      }
    });

    await animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.onTop ? topPosition : null,
      bottom: !widget.onTop ? topPosition : null,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: offsetAnimation,
        child: SafeArea(
          child: Center(
            child: _TapBounceContainer(
              onTap: () {
                widget.onTap?.call();
                animationController.reverse();
              },
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================================
// ===============================================

class _StandardSnackBar extends StatelessWidget {
  const _StandardSnackBar({
    required this.title,
    required this.message,
    this.error = false,
  });

  final String title;
  final String message;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width / 3,
        ),
        decoration: BoxDecoration(
          color: error
              ? Colors.red[800]!.withValues(alpha: 0.9)
              : Colors.green[800]!.withValues(alpha: 0.9),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 8),
              spreadRadius: 1,
              blurRadius: 30,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgIcon(
                error
                    ? CommunitySvgs.alertWarningAmberMaterialiconsround24px
                    : CommunitySvgs.actionCheckCircleMaterialicons24px,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: Font.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================
// ===============================================

class _TapBounceContainer extends StatefulWidget {
  const _TapBounceContainer({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  _TapBounceContainerState createState() => _TapBounceContainerState();
}

class _TapBounceContainerState extends State<_TapBounceContainer>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  final animationDuration = const Duration(milliseconds: 150);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
      upperBound: 0.04,
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: Transform.scale(scale: _scale, child: widget.child),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _closeSnackBar();
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    await _closeSnackBar();
  }

  Future<void> _closeSnackBar() async {
    await _controller.reverse();
    await Future<dynamic>.delayed(animationDuration);
    widget.onTap?.call();
  }
}
