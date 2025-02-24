library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef TooltipTriggeredCallback = void Function();

class _ExclusiveMouseRegion extends MouseRegion {
  const _ExclusiveMouseRegion({super.onEnter, super.onExit, super.child});

  @override
  _RenderExclusiveMouseRegion createRenderObject(BuildContext context) {
    return _RenderExclusiveMouseRegion(onEnter: onEnter, onExit: onExit);
  }
}

class _RenderExclusiveMouseRegion extends RenderMouseRegion {
  _RenderExclusiveMouseRegion({super.onEnter, super.onExit});

  static bool isOutermostMouseRegion = true;
  static bool foundInnermostMouseRegion = false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    final bool outermost = isOutermostMouseRegion;
    isOutermostMouseRegion = false;
    if (size.contains(position)) {
      isHit =
          hitTestChildren(result, position: position) || hitTestSelf(position);
      if ((isHit || behavior == HitTestBehavior.translucent) &&
          !foundInnermostMouseRegion) {
        foundInnermostMouseRegion = true;
        result.add(BoxHitTestEntry(this, position));
      }
    }

    if (outermost) {
      isOutermostMouseRegion = true;
      foundInnermostMouseRegion = false;
    }

    return isHit;
  }
}

class DFTooltipHack extends StatefulWidget {
  const DFTooltipHack({
    super.key,
    this.message,
    this.richMessage,
    this.height,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.excludeFromSemantics,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.exitDuration,
    this.enableTapToDismiss = true,
    this.triggerMode,
    this.enableFeedback,
    this.onTriggered,
    this.child,
  }) : assert(
         (message == null) != (richMessage == null),
         'Either `message` or `richMessage` must be specified',
       ),
       assert(
         richMessage == null || textStyle == null,
         'If `richMessage` is specified, `textStyle` will have no effect. '
         'If you wish to provide a `textStyle` for a rich tooltip, add the '
         '`textStyle` directly to the `richMessage` InlineSpan.',
       );

  final String? message;

  final InlineSpan? richMessage;

  final double? height;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final double? verticalOffset;

  final bool? preferBelow;

  final bool? excludeFromSemantics;

  final Widget? child;

  final Decoration? decoration;

  final TextStyle? textStyle;

  final TextAlign? textAlign;

  final Duration? waitDuration;

  final Duration? showDuration;

  final Duration? exitDuration;

  final bool enableTapToDismiss;

  final TooltipTriggerMode? triggerMode;

  final bool? enableFeedback;

  final TooltipTriggeredCallback? onTriggered;

  static final List<DFTooltipHackState> _openedTooltips =
      <DFTooltipHackState>[];

  static bool dismissAllToolTips() {
    if (_openedTooltips.isNotEmpty) {
      final List<DFTooltipHackState> openedTooltips = _openedTooltips.toList();
      for (final DFTooltipHackState state in openedTooltips) {
        state._scheduleDismissTooltip(withDelay: Duration.zero);
      }

      return true;
    }

    return false;
  }

  @override
  State<DFTooltipHack> createState() => DFTooltipHackState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      StringProperty(
        'message',
        message,
        showName: message == null,
        defaultValue: message == null ? null : kNoDefaultValue,
      ),
    );
    properties.add(
      StringProperty(
        'richMessage',
        richMessage?.toPlainText(),
        showName: richMessage == null,
        defaultValue: richMessage == null ? null : kNoDefaultValue,
      ),
    );
    properties.add(DoubleProperty('height', height, defaultValue: null));
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>(
        'padding',
        padding,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry>(
        'margin',
        margin,
        defaultValue: null,
      ),
    );
    properties.add(
      DoubleProperty('vertical offset', verticalOffset, defaultValue: null),
    );
    properties.add(
      FlagProperty(
        'position',
        value: preferBelow,
        ifTrue: 'below',
        ifFalse: 'above',
        showName: true,
      ),
    );
    properties.add(
      FlagProperty(
        'semantics',
        value: excludeFromSemantics,
        ifTrue: 'excluded',
        showName: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<Duration>(
        'wait duration',
        waitDuration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Duration>(
        'show duration',
        showDuration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Duration>(
        'exit duration',
        exitDuration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<TooltipTriggerMode>(
        'triggerMode',
        triggerMode,
        defaultValue: null,
      ),
    );
    properties.add(
      FlagProperty(
        'enableFeedback',
        value: enableFeedback,
        ifTrue: 'true',
        showName: true,
      ),
    );
    properties.add(
      DiagnosticsProperty<TextAlign>(
        'textAlign',
        textAlign,
        defaultValue: null,
      ),
    );
  }
}

class DFTooltipHackState extends State<DFTooltipHack>
    with SingleTickerProviderStateMixin {
  static const double _defaultVerticalOffset = 24;
  static const bool _defaultPreferBelow = true;
  static const EdgeInsetsGeometry _defaultMargin = EdgeInsets.zero;
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultHoverExitDuration = Duration(milliseconds: 100);
  static const Duration _defaultWaitDuration = Duration.zero;
  static const bool _defaultExcludeFromSemantics = false;
  static const TooltipTriggerMode _defaultTriggerMode =
      TooltipTriggerMode.longPress;
  static const bool _defaultEnableFeedback = true;
  static const TextAlign _defaultTextAlign = TextAlign.start;

  final OverlayPortalController _overlayController = OverlayPortalController();

  late bool _visible;
  late TooltipThemeData _tooltipTheme;

  Duration get _showDuration =>
      widget.showDuration ?? _tooltipTheme.showDuration ?? _defaultShowDuration;
  Duration get _hoverExitDuration =>
      widget.exitDuration ??
      _tooltipTheme.exitDuration ??
      _defaultHoverExitDuration;
  Duration get _waitDuration =>
      widget.waitDuration ?? _tooltipTheme.waitDuration ?? _defaultWaitDuration;
  TooltipTriggerMode get _triggerMode =>
      widget.triggerMode ?? _tooltipTheme.triggerMode ?? _defaultTriggerMode;
  bool get _enableFeedback =>
      widget.enableFeedback ??
      _tooltipTheme.enableFeedback ??
      _defaultEnableFeedback;

  String get _tooltipMessage =>
      widget.message ?? widget.richMessage!.toPlainText();

  Timer? _timer;
  AnimationController? _backingController;
  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
  }

  CurvedAnimation? _backingOverlayAnimation;
  CurvedAnimation get _overlayAnimation {
    return _backingOverlayAnimation ??= CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  LongPressGestureRecognizer? _longPressRecognizer;
  TapGestureRecognizer? _tapRecognizer;

  final Set<int> _activeHoveringPointerDevices = <int>{};

  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  void _handleStatusChanged(AnimationStatus status) {
    switch ((_animationStatus.isDismissed, status.isDismissed)) {
      case (false, true):
        DFTooltipHack._openedTooltips.remove(this);
        _overlayController.hide();
      case (true, false):
        _overlayController.show();
        DFTooltipHack._openedTooltips.add(this);
        SemanticsService.tooltip(_tooltipMessage);
      case (true, true) || (false, false):
        break;
    }
    _animationStatus = status;
  }

  void _scheduleShowTooltip({
    required Duration withDelay,
    Duration? showDuration,
  }) {
    void show() {
      if (!_visible) {
        return;
      }
      _controller.forward();
      _timer?.cancel();
      _timer =
          showDuration == null
              ? null
              : Timer(showDuration, _controller.reverse);
    }

    assert(
      !(_timer?.isActive ?? false) ||
          _controller.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );
    if (_controller.isDismissed && withDelay.inMicroseconds > 0) {
      _timer?.cancel();
      _timer = Timer(withDelay, show);
    } else {
      show();
    }
  }

  void _scheduleDismissTooltip({required Duration withDelay}) {
    assert(
      !(_timer?.isActive ?? false) ||
          _backingController?.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );

    _timer?.cancel();
    _timer = null;

    if (_backingController?.isForwardOrCompleted ?? false) {
      if (withDelay.inMicroseconds > 0) {
        _timer = Timer(withDelay, _controller.reverse);
      } else {
        _controller.reverse();
      }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    const Set<PointerDeviceKind> triggerModeDeviceKinds = <PointerDeviceKind>{
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.stylus,
      PointerDeviceKind.touch,
      PointerDeviceKind.unknown,
      PointerDeviceKind.trackpad,
    };
    switch (_triggerMode) {
      case TooltipTriggerMode.longPress:
        final LongPressGestureRecognizer recognizer =
            _longPressRecognizer ??= LongPressGestureRecognizer(
              debugOwner: this,
              supportedDevices: triggerModeDeviceKinds,
            );
        recognizer
          ..onLongPressCancel = _handleTapToDismiss
          ..onLongPress = _handleLongPress
          ..onLongPressUp = _handlePressUp
          ..addPointer(event);
      case TooltipTriggerMode.tap:
        final TapGestureRecognizer recognizer =
            _tapRecognizer ??= TapGestureRecognizer(
              debugOwner: this,
              supportedDevices: triggerModeDeviceKinds,
            );
        recognizer
          ..onTapCancel = _handleTapToDismiss
          ..onTap = _handleTap
          ..addPointer(event);
      case TooltipTriggerMode.manual:
        break;
    }
  }

  void _handleGlobalPointerEvent(PointerEvent event) {
    if (_tapRecognizer?.primaryPointer == event.pointer ||
        _longPressRecognizer?.primaryPointer == event.pointer) {
      return;
    }
    if ((_timer == null && _controller.isDismissed) ||
        event is! PointerDownEvent) {
      return;
    }
    _handleTapToDismiss();
  }

  void _handleTapToDismiss() {
    if (!widget.enableTapToDismiss) {
      return;
    }
    _scheduleDismissTooltip(withDelay: Duration.zero);
    _activeHoveringPointerDevices.clear();
  }

  void _handleTap() {
    if (!_visible) {
      return;
    }
    final bool tooltipCreated = _controller.isDismissed;
    if (tooltipCreated && _enableFeedback) {
      Feedback.forTap(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(
      withDelay: Duration.zero,
      showDuration:
          _activeHoveringPointerDevices.isEmpty ? _showDuration : null,
    );
  }

  void _handleLongPress() {
    if (!_visible) {
      return;
    }
    final bool tooltipCreated = _visible && _controller.isDismissed;
    if (tooltipCreated && _enableFeedback) {
      Feedback.forLongPress(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(withDelay: Duration.zero);
  }

  void _handlePressUp() {
    if (_activeHoveringPointerDevices.isNotEmpty) {
      return;
    }
    _scheduleDismissTooltip(withDelay: _showDuration);
  }

  void _handleMouseEnter(PointerEnterEvent event) {
    _activeHoveringPointerDevices.add(event.device);

    final List<DFTooltipHackState> tooltipsToDismiss =
        DFTooltipHack._openedTooltips
            .where(
              (DFTooltipHackState tooltip) =>
                  tooltip._activeHoveringPointerDevices.isEmpty,
            )
            .toList();
    for (final DFTooltipHackState tooltip in tooltipsToDismiss) {
      tooltip._scheduleDismissTooltip(withDelay: Duration.zero);
    }
    _scheduleShowTooltip(
      withDelay: tooltipsToDismiss.isNotEmpty ? Duration.zero : _waitDuration,
    );
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_activeHoveringPointerDevices.isEmpty) {
      return;
    }
    _activeHoveringPointerDevices.remove(event.device);
    if (_activeHoveringPointerDevices.isEmpty) {
      _scheduleDismissTooltip(withDelay: _hoverExitDuration);
    }
  }

  bool ensureTooltipVisible() {
    if (!_visible) {
      return false;
    }

    _timer?.cancel();
    _timer = null;
    if (_controller.isForwardOrCompleted) {
      return false;
    }
    _scheduleShowTooltip(withDelay: Duration.zero);

    return true;
  }

  @override
  void initState() {
    super.initState();

    GestureBinding.instance.pointerRouter.addGlobalRoute(
      _handleGlobalPointerEvent,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
    _tooltipTheme = TooltipTheme.of(context);
  }

  double _getDefaultTooltipHeight() {
    return switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows => 24.0,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS => 32.0,
    };
  }

  EdgeInsets _getDefaultPadding() {
    return switch (Theme.of(context).platform) {
      TargetPlatform.macOS || TargetPlatform.linux || TargetPlatform.windows =>
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      TargetPlatform.android || TargetPlatform.fuchsia || TargetPlatform.iOS =>
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    };
  }

  static double _getDefaultFontSize(TargetPlatform platform) {
    return switch (platform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows => 12.0,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS => 14.0,
    };
  }

  Widget _buildTooltipOverlay(BuildContext context) {
    final OverlayState overlayState = Overlay.of(
      context,
      debugRequiredFor: widget,
    );
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    final (
      TextStyle defaultTextStyle,
      BoxDecoration defaultDecoration,
    ) = switch (Theme.of(context)) {
      ThemeData(
        brightness: Brightness.dark,
        :final TextTheme textTheme,
        :final TargetPlatform platform,
      ) =>
        (
          textTheme.bodyMedium!.copyWith(
            color: Colors.black,
            fontSize: _getDefaultFontSize(platform),
          ),
          BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ThemeData(
        brightness: Brightness.light,
        :final TextTheme textTheme,
        :final TargetPlatform platform,
      ) =>
        (
          textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontSize: _getDefaultFontSize(platform),
          ),
          BoxDecoration(
            color: Colors.grey[700]!.withValues(alpha: 0.9),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
        ),
    };

    final TooltipThemeData tooltipTheme = _tooltipTheme;
    final _TooltipOverlay overlayChild = _TooltipOverlay(
      richMessage: widget.richMessage ?? TextSpan(text: widget.message),
      height:
          widget.height ?? tooltipTheme.height ?? _getDefaultTooltipHeight(),
      padding: widget.padding ?? tooltipTheme.padding ?? _getDefaultPadding(),
      margin: widget.margin ?? tooltipTheme.margin ?? _defaultMargin,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      decoration:
          widget.decoration ?? tooltipTheme.decoration ?? defaultDecoration,
      textStyle: widget.textStyle ?? tooltipTheme.textStyle ?? defaultTextStyle,
      textAlign:
          widget.textAlign ?? tooltipTheme.textAlign ?? _defaultTextAlign,
      animation: _overlayAnimation,
      target: target,
      verticalOffset:
          widget.verticalOffset ??
          tooltipTheme.verticalOffset ??
          _defaultVerticalOffset,
      preferBelow:
          widget.preferBelow ?? tooltipTheme.preferBelow ?? _defaultPreferBelow,
    );

    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(
      _handleGlobalPointerEvent,
    );
    DFTooltipHack._openedTooltips.remove(this);

    _longPressRecognizer?.onLongPressCancel = null;
    _longPressRecognizer?.dispose();
    _tapRecognizer?.onTapCancel = null;
    _tapRecognizer?.dispose();
    _timer?.cancel();
    _backingController?.dispose();
    _backingOverlayAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tooltipMessage.isEmpty) {
      return widget.child ?? const SizedBox.shrink();
    }
    final bool excludeFromSemantics =
        widget.excludeFromSemantics ??
        _tooltipTheme.excludeFromSemantics ??
        _defaultExcludeFromSemantics;
    Widget result = Semantics(
      tooltip: excludeFromSemantics ? null : _tooltipMessage,
      child: widget.child,
    );

    if (_visible) {
      result = _ExclusiveMouseRegion(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        child: Listener(
          onPointerDown: _handlePointerDown,
          behavior: HitTestBehavior.opaque,
          child: result,
        ),
      );
    }

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildTooltipOverlay,
      child: result,
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  _TooltipPositionDelegate({
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
  });

  final Offset target;

  final double verticalOffset;

  final bool preferBelow;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return positionDependentBox(
      size: size,
      childSize: childSize,
      target: target,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
    );
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        verticalOffset != oldDelegate.verticalOffset ||
        preferBelow != oldDelegate.preferBelow;
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.height,
    required this.richMessage,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.preferBelow,
    this.padding,
    this.margin,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.onEnter,
    this.onExit,
  });

  final InlineSpan richMessage;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Animation<double> animation;
  final Offset target;
  final double verticalOffset;
  final bool preferBelow;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  @override
  Widget build(BuildContext context) {
    Widget result = FadeTransition(
      opacity: animation,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: Semantics(
            container: true,
            child: Container(
              decoration: decoration,
              padding: padding,
              margin: margin,
              child: Center(
                widthFactor: 1,
                heightFactor: 1,
                child: Text.rich(
                  richMessage,
                  style: textStyle,
                  textAlign: textAlign,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (onEnter != null || onExit != null) {
      result = _ExclusiveMouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: result,
      );
    }

    // SNG - this is the only change.  allows scrollwheel to work when hovering over tooltip
    // added IgnorePointer to avoid hover over tooltip and our slideout sidebars getting dismissed
    // when mouse is over the tooltip.
    return IgnorePointer(
      child: Positioned.fill(
        bottom: MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0,
        child: Listener(
          onPointerSignal: (event) {
            if (event is PointerScrollEvent) {
              // hide tooltip otherwise it will stick with the mouse pointer

              DFTooltipHack.dismissAllToolTips();

              Scrollable.of(context).position.jumpTo(
                Scrollable.of(context).position.pixels + event.scrollDelta.dy,
              );
            }
          },
          child: CustomSingleChildLayout(
            delegate: _TooltipPositionDelegate(
              target: target,
              verticalOffset: verticalOffset,
              preferBelow: preferBelow,
            ),
            child: result,
          ),
        ),
      ),
    );
  }
}
