import 'dart:async';
import 'dart:math';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/image/super_image_source.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:random_string/random_string.dart';

double initScale({Size? imageSize, Size? size, double? initialScale}) {
  // final n1 = imageSize.height / imageSize.width;
  // final n2 = size.height / size.width;

  // if (n1 > n2) {
  //   final FittedSizes fittedSizes =
  //       applyBoxFit(BoxFit.contain, imageSize, size);
  //   final Size destinationSize = fittedSizes.destination;

  //   return size.width / destinationSize.width;
  // } else if (n1 / n2 < 1 / 4) {
  //   final FittedSizes fittedSizes =
  //       applyBoxFit(BoxFit.contain, imageSize, size);
  //   final Size destinationSize = fittedSizes.destination;

  //   return size.height / destinationSize.height;
  // }

  return .9;
}

class ImageViewer extends StatefulWidget {
  const ImageViewer({
    required this.index,
    required this.swiperItems,
  });

  final int index;
  final List<ImageSwiperItem> swiperItems;

  @override
  _ImageSwiperState createState() => _ImageSwiperState();
}

class _ImageSwiperState extends State<ImageViewer>
    with SingleTickerProviderStateMixin {
  StreamController<int> rebuildIndex = StreamController<int>.broadcast();
  StreamController<bool> rebuildSwiper = StreamController<bool>.broadcast();
  AnimationController? _animationController;
  Animation<double>? _animation;
  late void Function() animationListener;
  List<double> doubleTapScales = <double>[.9, 3.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  late int currentIndex;
  bool _showSwiper = true;

  @override
  void initState() {
    currentIndex = widget.index;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    rebuildIndex.close();
    rebuildSwiper.close();
    _animationController?.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  Widget heroBuilderForSlidingPage(Widget result, int index, String heroTag) {
    if (index < min(9, widget.swiperItems.length)) {
      return Hero(
        tag: heroTag,
        child: result,
      );
    } else {
      return result;
    }
  }

  GestureConfig initGestureConfigHandler(
    ExtendedImageState state,
    Size size,
  ) {
    double initialScale = 1.0;

    if (state.extendedImageInfo != null) {
      initialScale = initScale(
        size: size,
        initialScale: initialScale,
        imageSize: Size(
          state.extendedImageInfo!.image.width.toDouble(),
          state.extendedImageInfo!.image.height.toDouble(),
        ),
      );
    }
    return GestureConfig(
      inPageView: true,
      initialScale: initialScale,
      maxScale: 10.0,
      animationMaxScale: 10.0,
    );
  }

  void onDoubleTap(ExtendedImageGestureState state) {
    final pointerDownPosition = state.pointerDownPosition;
    final double? begin = state.gestureDetails!.totalScale;
    double end;

    _animation?.removeListener(animationListener);

    _animationController!.stop();

    _animationController!.reset();

    if (begin == doubleTapScales[0]) {
      end = doubleTapScales[1];
    } else {
      end = doubleTapScales[0];
    }

    animationListener = () {
      state.handleDoubleTap(
        scale: _animation!.value,
        doubleTapPosition: pointerDownPosition,
      );
    };
    _animation =
        _animationController!.drive(Tween<double>(begin: begin, end: end));

    _animation!.addListener(animationListener);

    _animationController!.forward();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final size = MediaQuery.of(context).size;

    final imageSrc = widget.swiperItems[index].imageSrc;
    final String heroTag = widget.swiperItems[index].heroTag;

    Widget? image;

    if (imageSrc.isFileImage) {
      image = ExtendedImage.file(
        File(imageSrc.path!),
        fit: BoxFit.contain,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        heroBuilderForSlidingPage: (Widget result) =>
            heroBuilderForSlidingPage(result, index, heroTag),
        initGestureConfigHandler: (state) =>
            initGestureConfigHandler(state, size),
        onDoubleTap: onDoubleTap,
      );
    } else if (imageSrc.isNetworkImage) {
      if (imageSrc.url!.isAssetUrl) {
        return ExtendedImage.asset(
          imageSrc.url!,
          fit: BoxFit.contain,
          enableSlideOutPage: true,
          mode: ExtendedImageMode.gesture,
          heroBuilderForSlidingPage: (Widget result) =>
              heroBuilderForSlidingPage(result, index, heroTag),
          initGestureConfigHandler: (state) =>
              initGestureConfigHandler(state, size),
          onDoubleTap: onDoubleTap,
        );
      }

      image = ExtendedImage.network(
        imageSrc.url!,
        fit: BoxFit.contain,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        heroBuilderForSlidingPage: (Widget result) =>
            heroBuilderForSlidingPage(result, index, heroTag),
        initGestureConfigHandler: (state) =>
            initGestureConfigHandler(state, size),
        onDoubleTap: onDoubleTap,
      );
    } else if (imageSrc.isMemoryImage) {
      image = ExtendedImage.memory(
        imageSrc.memory!,
        fit: BoxFit.contain,
        enableSlideOutPage: true,
        mode: ExtendedImageMode.gesture,
        heroBuilderForSlidingPage: (Widget result) =>
            heroBuilderForSlidingPage(result, index, heroTag),
        initGestureConfigHandler: (state) =>
            initGestureConfigHandler(state, size),
        onDoubleTap: onDoubleTap,
      );
    }

    return GestureDetector(
      onTap: () {
        slidePagekey.currentState!.popPage();
        Navigator.pop(context);
      },
      child: image,
    );
  }

  Widget _toolsButton() {
    return Builder(
      builder: (BuildContext context) {
        final SuperImageSource imageSrc =
            widget.swiperItems[currentIndex].imageSrc;

        if (imageSrc.isFileImage) {
          return IconButton(
            iconSize: 44,
            icon: const Icon(Icons.open_in_browser),
            onPressed: () {
              final String? url =
                  widget.swiperItems[currentIndex].imageSrc.path;
              OpenFile.open(url);
            },
          );
        } else if (imageSrc.isNetworkImage) {
          return PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String result) {
              switch (result) {
                case 'copy':
                  final String? url =
                      widget.swiperItems[currentIndex].imageSrc.url;
                  Clipboard.setData(ClipboardData(text: url));

                  Utils.showSnackbar(context, 'URL copied to clipboard');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'copy',
                  child: Text('Copy URL'),
                ),
              ];
            },
          );
        }

        return NothingWidget();
      },
    );
  }

  bool _defaultCanMovePage(GestureDetails? gestureDetails) =>
      widget.swiperItems.length > 1;

  @override
  Widget build(BuildContext context) {
    final Widget imagePage = Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          ExtendedImageGesturePageView.builder(
            canMovePage: _defaultCanMovePage,
            itemBuilder: _itemBuilder,
            itemCount: widget.swiperItems.length,
            onPageChanged: (int index) {
              currentIndex = index;
              rebuildIndex.add(index);
            },
            controller: PageController(
              initialPage: currentIndex,
            ),
            physics: const BouncingScrollPhysics(),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: _toolsButton(),
          )
        ],
      ),
    );

    return ExtendedImageSlidePage(
      slidePageBackgroundHandler: (Offset offset, Size pageSize) {
        return Colors.black54;
      },
      key: slidePagekey,
      onSlidingPage: (state) {
        final showSwiper = !state.isSliding;
        if (showSwiper != _showSwiper) {
          _showSwiper = showSwiper;
          rebuildSwiper.add(_showSwiper);
        }
      },
      child: imagePage,
    );
  }
}

class ImageSwiperItem {
  ImageSwiperItem(this.imageSrc, {this.caption = ''})
      : heroTag = randomString(10);

  final SuperImageSource imageSrc;
  final String caption;
  final String heroTag;
}
