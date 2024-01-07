import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class WaveText extends StatefulWidget {
  const WaveText({
    required this.text,
    required this.boxHeight,
    required this.boxWidth,
    required this.waveColor,
    super.key,
    this.textStyle = const TextStyle(
      fontSize: 140,
      fontWeight: FontWeight.bold,
    ),
    this.textAlign = TextAlign.left,
    this.loadDuration = const Duration(seconds: 6),
    this.waveDuration = const Duration(seconds: 2),
    this.loadUntil = 1.0,
  }) : assert(loadUntil > 0 && loadUntil <= 1.0, '');

  final TextStyle textStyle;
  final TextAlign textAlign;
  final Duration loadDuration;
  final Duration waveDuration;
  final double boxHeight;
  final double boxWidth;
  final String text;
  final Color waveColor;
  final double loadUntil;

  @override
  State<WaveText> createState() => _TextLiquidFillState();
}

class _TextLiquidFillState extends State<WaveText>
    with TickerProviderStateMixin {
  final _textKey = GlobalKey();

  late AnimationController _waveController;
  late AnimationController _loadController;
  late Animation<double> _loadValue;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );

    _loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );

    _loadValue = Tween<double>(
      begin: 0,
      end: widget.loadUntil,
    ).animate(_loadController);

    if (1.0 == widget.loadUntil) {
      _loadValue.addStatusListener((status) {
        if (AnimationStatus.completed == status) {
          _waveController.stop();
        }
      });
    }

    _waveController.repeat();
    _loadController.forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _loadController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SaveLayer(
      child: Container(
        color: Colors.white,
        child: WidgetMask(
          blendMode: BlendMode.dstATop,
          mask: Text(
            widget.text,
            key: _textKey,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
          child: SizedBox(
            height: widget.boxHeight,
            width: widget.boxWidth,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (BuildContext context, Widget? child) {
                return CustomPaint(
                  painter: _WavePainter(
                    textKey: _textKey,
                    waveValue: _waveController.value,
                    loadValue: _loadValue.value,
                    boxHeight: widget.boxHeight,
                    waveColor: widget.waveColor,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================================================

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.textKey,
    required this.waveValue,
    required this.loadValue,
    required this.boxHeight,
    required this.waveColor,
  });
  static const _pi2 = 2 * pi;
  final GlobalKey textKey;
  final double waveValue;
  final double loadValue;
  final double boxHeight;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final RenderBox textBox =
        textKey.currentContext!.findRenderObject()! as RenderBox;
    final textHeight = textBox.size.height;
    final baseHeight =
        (boxHeight / 2) + (textHeight / 2) - (loadValue * textHeight);

    final width = size.width;
    final height = size.height;
    final path = Path();
    path.moveTo(0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(i, baseHeight + sin(_pi2 * (i / width + waveValue)) * 8);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
