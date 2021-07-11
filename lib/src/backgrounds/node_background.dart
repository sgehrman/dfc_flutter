import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NodeBackground extends StatelessWidget {
  const NodeBackground({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: NodeBackgroundAnimation()),
        Positioned.fill(child: child!),
      ],
    );
  }
}

class NodeBackgroundAnimation extends StatefulWidget {
  @override
  _NodeBackgroundAnimationState createState() =>
      _NodeBackgroundAnimationState();
}

const total = 22;
Random random = Random();

class AnimationVal {
  AnimationVal(this.animation) {
    const double maxOpacity = .3;
    final radiusVal = random.nextDouble();
    radius = 4 + radiusVal * 8;

    final double opac = radiusVal * maxOpacity;

    paintCircle = Paint()
      ..color = Colors.blue.withOpacity(max(.05, opac))
      ..isAntiAlias = true;

    const gradient = RadialGradient(
      colors: [
        Colors.transparent,
        Colors.red,
      ],
    );

    gradientPaint = Paint();
    gradientPaint.shader = gradient.createShader(Rect.fromCircle(
      center: Offset.zero,
      radius: radius,
    ));
  }

  final Animation<Offset> animation;
  late double radius;
  late Paint paintCircle;
  late Paint gradientPaint;
}

class _NodeBackgroundAnimationState extends State<NodeBackgroundAnimation>
    with TickerProviderStateMixin {
  List<AnimationVal>? animations;
  late List<AnimationController> controllers;
  final Random random = Random();

  final Color backgroudPatternBlue = Colors.blue.withAlpha(20);
  final Color backgroudCirclePatternBlue = const Color.fromRGBO(0, 55, 255, .1);
  final Color backgroudPatternBlueDark = const Color(0x05FFFFFF);
  final Color backgroudCirclePatternBlueDark = const Color(0x10FFFFFF);
  ui.Image? image;

  Future<void> _loadImage() async {
    final ByteData bd = await rootBundle.load('assets/images/lsd.png');

    final Uint8List bytes = Uint8List.view(bd.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image img = (await codec.getNextFrame()).image;

    setState(() {
      image = img;
    });
  }

  @override
  void initState() {
    super.initState();

    controllers = List.generate(total, (i) {
      return AnimationController(
          vsync: this,
          duration: Duration(seconds: 15, milliseconds: random.nextInt(5000)));
    });

    animations = List.generate(total, (i) {
      final tween = Tween<Offset>(
          begin: Offset(random.nextDouble(), random.nextDouble()),
          end: Offset(random.nextDouble(), random.nextDouble()));
      final a = tween.animate(controllers[i]);
      a
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            tween.begin = tween.end;
            controllers[i].reset();
            tween.end = Offset(random.nextDouble(), random.nextDouble());
            controllers[i].forward();
          }
        });
      return AnimationVal(a);
    });

    for (final f in controllers) {
      f.forward();
    }

    // disabled
    if ('x' == 's') {
      _loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BackgroundPainter(
        animations,
        Theme.of(context).brightness == Brightness.light
            ? backgroudPatternBlue
            : backgroudPatternBlueDark,
        image,
      ),
    );
  }

  @override
  void dispose() {
    for (final f in controllers) {
      f.dispose();
    }
    super.dispose();
  }
}

class BackgroundPainter extends CustomPainter {
  BackgroundPainter(this.animations, Color line, this.image)
      : paintLine = Paint()
          ..color = line
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 1,
        super();

  final Paint paintLine;
  List<AnimationVal>? animations;
  ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < animations!.length; i++) {
      canvas.drawCircle(
        getOffset(animations![i].animation, size),
        animations![i].radius,
        animations![i].paintCircle,
      );
      // canvas.drawCircle(
      //   getOffset(animations[i].animation, size),
      //   animations[i].radius,
      //   animations[i].gradientPaint,
      // );

      final Rect rect = Rect.fromCircle(
        center: getOffset(animations![i].animation, size),
        radius: animations![i].radius,
      );

      if (image != null) {
        paintImage(
          canvas: canvas,
          image: image!,
          rect: rect,
        );
      }
    }

    for (int i = 3; i < animations!.length; i += 3) {
      canvas.drawLine(getOffset(animations![i - 3].animation, size),
          getOffset(animations![i].animation, size), paintLine);
      canvas.drawLine(getOffset(animations![i - 2].animation, size),
          getOffset(animations![i].animation, size), paintLine);
      canvas.drawLine(getOffset(animations![i - 1].animation, size),
          getOffset(animations![i].animation, size), paintLine);
    }
  }

  Offset getOffset(Animation<Offset> offset, Size size) => Offset(
        (offset.value.dx * (size.width * 1.3)) - (size.width * .15),
        (offset.value.dy * (size.height * 1.3)) - (size.height * .15),
      );

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
