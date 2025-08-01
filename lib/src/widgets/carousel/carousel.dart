import 'dart:math' as math;

import 'package:dfc_flutter/src/widgets/carousel/carousel_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    required this.items,
    required this.height,
    required this.autoPlay,
    required this.infiniteScroll,
    required this.enlargeCenterPage,
    required this.itemWidth,
    this.initialPage = 0,
    this.fillViewport = false,
    this.showIndicator = true,
    this.showControlsHover = false,
  });

  final List<Widget> items;
  final double height;
  final bool autoPlay;
  final bool infiniteScroll;
  final bool enlargeCenterPage;
  final double itemWidth;
  final int initialPage;
  final bool fillViewport;
  final bool showIndicator;
  final bool showControlsHover;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final FlutterCarouselController _controller = FlutterCarouselController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double viewportFraction = math.min(
          0.9,
          widget.itemWidth / constraints.maxWidth,
        );

        // we set it to 1 for purchase, but if not very wide, just make it 0
        var initialPage = widget.initialPage;
        if (viewportFraction >= 0.5) {
          initialPage = 0;
        }

        return CarouselControls(
          showOnHover: widget.showControlsHover,
          child: FlutterCarousel(
            options: FlutterCarouselOptions(
              height: widget.height,
              slideIndicator: CircularSlideIndicator(),
              autoPlay: widget.autoPlay,
              enableInfiniteScroll: widget.infiniteScroll,
              floatingIndicator: false,
              disableCenter: true,
              showIndicator: widget.showIndicator,
              enlargeCenterPage: widget.enlargeCenterPage,
              viewportFraction: widget.fillViewport ? 1.0 : viewportFraction,
              indicatorMargin: 40,
              initialPage: initialPage,
              autoPlayCurve: Curves.easeInOut,
              clipBehavior: Clip.none, // shadows
              controller: _controller,
            ),
            items: widget.items,
          ),
          onNext: () {
            _controller.nextPage();
          },
          onPrevious: () {
            _controller.previousPage();
          },
        );
      },
    );
  }
}
