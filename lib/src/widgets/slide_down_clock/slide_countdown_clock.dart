import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

import 'package:dfc_flutter/src/widgets/slide_down_clock/digit.dart';

import 'package:dfc_flutter/src/widgets/slide_down_clock/slide_direction.dart';

class SlideCountdownClock extends StatefulWidget {
  const SlideCountdownClock({
    Key? key,
    required this.duration,
    this.textStyle = const TextStyle(
      fontSize: 30,
      color: Colors.black,
    ),
    this.separatorTextStyle,
    this.decoration,
    this.tightLabel = false,
    this.separator = '',
    this.slideDirection = SlideDirection.down,
    this.onDone,
    this.shouldShowDays = false,
    this.shouldShowHours = true,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final Duration duration;
  final TextStyle textStyle;
  final TextStyle? separatorTextStyle;
  final String separator;
  final BoxDecoration? decoration;
  final SlideDirection slideDirection;
  final VoidCallback? onDone;
  final EdgeInsets padding;
  final bool tightLabel;
  final bool shouldShowDays;
  final bool shouldShowHours;

  @override
  SlideCountdownClockState createState() => SlideCountdownClockState();
}

class SlideCountdownClockState extends State<SlideCountdownClock> {
  late bool shouldShowDays;
  late Duration timeLeft;
  late Stream<DateTime> initStream;
  StreamSubscription<DateTime>? _streamSubscription;
  late StreamController<DateTime> _mainStream;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.duration;
    shouldShowDays = widget.shouldShowDays;

    if (timeLeft.inHours > 99) {
      shouldShowDays = true;
    }

    _init();
  }

  @override
  void didUpdateWidget(SlideCountdownClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    _init();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  void _init() {
    final time = DateTime.now();
    initStream =
        Stream<DateTime>.periodic(const Duration(milliseconds: 1000), (_) {
      timeLeft -= const Duration(seconds: 1);
      return time;
    });

    _mainStream = StreamController.broadcast();

    if (_streamSubscription != null) {
      _streamSubscription!.cancel();
    }

    _streamSubscription = initStream.listen(
      (value) {
        if (timeLeft.inSeconds == 0) {
          _streamSubscription!.pause();

          Future.delayed(const Duration(milliseconds: 1000), () {
            if (widget.onDone != null) {
              widget.onDone!();
            }
          });
        } else {
          _mainStream.add(value);
        }
      },
    );
  }

  List<Widget> _buildDigits() {
    final List<Widget> result = <Widget>[];

    if (shouldShowDays) {
      Widget dayDigits;

      if (timeLeft.inDays > 99) {
        final List<int Function(DateTime)> digits = [];

        for (int i = timeLeft.inDays.toString().length - 1; i >= 0; i--) {
          digits.add((DateTime time) =>
              ((timeLeft.inDays) ~/ math.pow(10, i) % math.pow(10, 1)).toInt());
        }

        dayDigits =
            _buildDigitForLargeNumber(digits, DateTime.now(), 'daysHundreds');
      } else {
        dayDigits = _buildDigit(
          (DateTime time) => (timeLeft.inDays) ~/ 10,
          (DateTime time) => (timeLeft.inDays) % 10,
          DateTime.now(),
          'Days',
        );
      }

      result.add(dayDigits);
    }

    if (widget.shouldShowHours) {
      if (result.isNotEmpty) {
        result.add(_buildSpace());
        final sep = _buildSeparator();
        if (sep != null) {
          result.add(sep);
          result.add(_buildSpace());
        }
      }

      result.add(_buildDigit(
        (DateTime time) => (timeLeft.inHours % 24) ~/ 10,
        (DateTime time) => (timeLeft.inHours % 24) % 10,
        DateTime.now(),
        'Hours',
      ));
    }

    if (result.isNotEmpty) {
      result.add(_buildSpace());
      final sep = _buildSeparator();
      if (sep != null) {
        result.add(sep);
        result.add(_buildSpace());
      }
    }

    result.add(_buildDigit(
      (DateTime time) => (timeLeft.inMinutes % 60) ~/ 10,
      (DateTime time) => (timeLeft.inMinutes % 60) % 10,
      DateTime.now(),
      'minutes',
    ));

    result.add(_buildSpace());
    final sep = _buildSeparator();
    if (sep != null) {
      result.add(sep);
      result.add(_buildSpace());
    }

    result.add(_buildDigit(
      (DateTime time) => (timeLeft.inSeconds % 60) ~/ 10,
      (DateTime time) => (timeLeft.inSeconds % 60) % 10,
      DateTime.now(),
      'seconds',
    ));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildDigits(),
    );
  }

  Widget _buildSpace() {
    return const SizedBox(width: 3);
  }

  Widget? _buildSeparator() {
    if (Utils.isNotEmpty(widget.separator)) {
      return Text(
        widget.separator,
        style: widget.separatorTextStyle ?? widget.textStyle,
      );
    }

    return null;
  }

  Widget _buildDigitForLargeNumber(
    List<int Function(DateTime)> digits,
    DateTime startTime,
    String id,
  ) {
    final String timeLeftString = timeLeft.inDays.toString();
    final List<Widget> rows = [];
    for (int i = 0; i < timeLeftString.toString().length; i++) {
      rows.add(
        Container(
          decoration: widget.decoration,
          padding: widget.tightLabel
              ? const EdgeInsets.only(left: 3)
              : EdgeInsets.zero,
          child: Digit(
            padding: widget.padding,
            itemStream: _mainStream.stream.map<int>(digits[i]),
            initValue: digits[i](startTime),
            id: id,
            decoration: widget.decoration,
            slideDirection: widget.slideDirection,
            textStyle: widget.textStyle,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ),
      ],
    );
  }

  Widget _buildDigit(
    int Function(DateTime) tensDigit,
    int Function(DateTime) onesDigit,
    DateTime startTime,
    String id,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: widget.decoration,
              padding: widget.tightLabel
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 3),
              child: Digit(
                padding: widget.padding,
                itemStream: _mainStream.stream.map<int>(tensDigit),
                initValue: tensDigit(startTime),
                id: id,
                decoration: widget.decoration,
                slideDirection: widget.slideDirection,
                textStyle: widget.textStyle,
              ),
            ),
            Container(
              decoration: widget.decoration,
              padding: widget.tightLabel
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 3),
              child: Digit(
                padding: widget.padding,
                itemStream: _mainStream.stream.map<int>(onesDigit),
                initValue: onesDigit(startTime),
                decoration: widget.decoration,
                slideDirection: widget.slideDirection,
                textStyle: widget.textStyle,
                id: id,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
