import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/widgets/slide_down_clock/clip_digit.dart';
import 'package:dfc_flutter/src/widgets/slide_down_clock/slide_direction.dart';

class Digit extends StatefulWidget {
  const Digit({
    required this.itemStream,
    required this.initValue,
    required this.id,
    required this.textStyle,
    required this.decoration,
    required this.slideDirection,
    required this.padding,
  });

  final Stream<int> itemStream;
  final int initValue;
  final String id;
  final TextStyle textStyle;
  final BoxDecoration? decoration;
  final SlideDirection slideDirection;
  final EdgeInsets padding;

  @override
  _DigitState createState() => _DigitState();
}

class _DigitState extends State<Digit> with SingleTickerProviderStateMixin {
  StreamSubscription<int>? _streamSubscription;
  int? _currentValue = 0;
  int _nextValue = 0;
  late AnimationController _controller;

  bool haveData = false;

  final Animatable<Offset> _slideUpTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  );
  late Animation<Offset> _slideUpAnimation;

  final Animatable<Offset> _slideDownTween = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  );
  late Animation<Offset> _slideDownAnimation;

  final Animatable<double> _opacityTween = Tween<double>(
    begin: 0,
    end: 1,
  );
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _slideUpAnimation = _controller.drive(_slideUpTween);
    _slideDownAnimation = _controller.drive(_slideDownTween);
    _opacityAnimation = _controller.drive(_opacityTween);

    startStreams();
  }

  void animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reset();
    }

    if (status == AnimationStatus.dismissed) {
      _currentValue = _nextValue;
    }
  }

  @override
  void didUpdateWidget(Digit oldWidget) {
    super.didUpdateWidget(oldWidget);

    startStreams();
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void startStreams() {
    try {
      _controller.removeStatusListener(animationListener);
      if (_streamSubscription != null) {
        _streamSubscription!.cancel();
      }
    } catch (error) {
      print(error);
    }

    _controller.addStatusListener(animationListener);

    _currentValue = widget.initValue;
    _streamSubscription = widget.itemStream.distinct().listen((value) {
      haveData = true;
      if (_currentValue == null) {
        _currentValue = value;
      } else if (value != _currentValue) {
        _nextValue = value;
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fakeWidget = Opacity(
      opacity: 0.0,
      child: Text(
        '9',
        style: widget.textStyle,
        textScaleFactor: 1.0,
        textAlign: TextAlign.center,
      ),
    );

    return Container(
      padding: widget.padding,
      alignment: Alignment.center,
      decoration: widget.decoration ?? const BoxDecoration(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, w) {
          return Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              if (haveData)
                FractionalTranslation(
                  translation: (widget.slideDirection == SlideDirection.down)
                      ? _slideUpAnimation.value
                      : -_slideUpAnimation.value,
                  child: ClipRect(
                    clipper: ClipHalfRect(
                      percentage: _slideUpAnimation.value.dy,
                      isUp: false,
                      slideDirection: widget.slideDirection,
                    ),
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: Text(
                        '$_nextValue',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                        style: widget.textStyle,
                      ),
                    ),
                  ),
                ),
              FractionalTranslation(
                translation: (widget.slideDirection == SlideDirection.down)
                    ? _slideDownAnimation.value
                    : -_slideDownAnimation.value,
                child: ClipRect(
                  clipper: ClipHalfRect(
                    percentage: _slideDownAnimation.value.dy,
                    isUp: false,
                    slideDirection: widget.slideDirection,
                  ),
                  child: Text(
                    '$_currentValue',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                    style: widget.textStyle,
                  ),
                ),
              ),
              fakeWidget,
            ],
          );
        },
      ),
    );
  }
}
