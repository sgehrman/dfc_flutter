import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

class WaveText extends StatefulWidget {
  const WaveText({
    required this.text,
    required this.boxHeight,
    required this.boxWidth,
    required this.textColor,
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
    this.repeatCount = -1,
  }) : assert(loadUntil > 0 && loadUntil <= 1.0, '');

  final TextStyle textStyle;
  final TextAlign textAlign;
  final Duration loadDuration;
  final Duration waveDuration;
  final double boxHeight;
  final double boxWidth;
  final int repeatCount;
  final String text;
  final Color waveColor;
  final Color textColor;
  final double loadUntil;

  @override
  State<WaveText> createState() => _TextLiquidFillState();
}

class _TextLiquidFillState extends State<WaveText>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _loadController;
  late Animation<double> _loadValue;
  final _PathCache _pathCache = _PathCache();
  int repeats = 0;

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

    if (widget.repeatCount == -1) {
      _waveController.repeat();
    } else {
      _waveController.addStatusListener(
        (status) {
          switch (status) {
            case AnimationStatus.completed:
            case AnimationStatus.dismissed:
              if (repeats++ < widget.repeatCount) {
                _waveController.forward();
              }
              break;
            case AnimationStatus.forward:
              break;
            case AnimationStatus.reverse:
              break;
          }
        },
      );
      _waveController.forward();
    }

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
        color: widget.textColor,
        child: WidgetMask(
          blendMode: BlendMode.dstATop,
          mask: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: widget.textStyle,
          ),
          child: SizedBox(
            height: widget.boxHeight,
            width: widget.boxWidth,
            child: Builder(
              builder: (context) {
                return AnimatedBuilder(
                  animation: _waveController,
                  builder: (BuildContext context, Widget? child) {
                    return CustomPaint(
                      painter: _WavePainter(
                        pathCache: _pathCache,
                        waveValue: _waveController.value,
                        loadValue: _loadValue.value,
                        boxHeight: widget.boxHeight,
                        waveColor: widget.waveColor,
                      ),
                    );
                  },
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
    required this.pathCache,
    required this.waveValue,
    required this.loadValue,
    required this.boxHeight,
    required this.waveColor,
  });

  final _PathCache pathCache;
  final double waveValue;
  final double loadValue;
  final double boxHeight;
  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = pathCache.path(
      width: size.width,
      boxHeight: boxHeight,
      height: size.height,
      waveValue: waveValue,
      loadValue: loadValue,
    );

    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// =====================================================

class _PathCache {
  final Map<String, Path> _cache = {};
  double _lastWidth = 0;
  double _lastHeight = 0;
  double _lastBoxHeight = 0;
  static const _pi2 = 2 * pi;

  Path path({
    required double width,
    required double height,
    required double waveValue,
    required double loadValue,
    required double boxHeight,
  }) {
    if (_lastBoxHeight != boxHeight ||
        _lastHeight != height ||
        _lastWidth != width) {
      _cache.clear();

      _lastWidth = width;
      _lastHeight = height;
      _lastBoxHeight = boxHeight;
    }

    final cacheKey =
        '$width:$height:$boxHeight:${waveValue.toStringAsFixed(2)}:${loadValue.toStringAsFixed(2)}';

    final cached = _cache[cacheKey];
    if (cached != null) {
      return cached;
    }

    final baseHeight =
        (boxHeight / 2) + (boxHeight / 2) - (loadValue * boxHeight);

    final path = Path();
    path.moveTo(0, baseHeight);
    for (var i = 0.0; i < width; i++) {
      path.lineTo(i, baseHeight + sin(_pi2 * (i / width + waveValue)) * 8);
    }

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    _cache[cacheKey] = path;

    return path;
  }
}
