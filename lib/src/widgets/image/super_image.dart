import 'dart:io';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/image/image_viewer.dart';
import 'package:dfc_flutter/src/widgets/image/super_image_source.dart';
import 'package:dfc_flutter/src/widgets/transparent_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SuperImage extends StatelessWidget {
  const SuperImage(
    this.imageSrc, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.enableViewer = false,
    this.swiperImageSrcs,
  }) : super(key: key);

  final SuperImageSource imageSrc;
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool enableViewer;
  final List<SuperImageSource>? swiperImageSrcs;

  Widget? _loadStateChanged(BuildContext context, ExtendedImageState state) {
    Widget? result;

    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (imageSrc.isNetworkImage) {
          result = const Center(
            child: CircularProgressIndicator(),
          );
        }
        break;
      case LoadState.failed:
        result = InkWell(
          onTap: () {
            state.reLoadImage();
          },
          child: const Icon(
            Icons.error,
            size: 30,
            color: Colors.red,
          ),
        );
        break;
      case LoadState.completed:
        if (enableViewer) {
          // not sure what this is for
          // final Widget child = ExtendedRawImage(
          //   image: state.extendedImageInfo?.image,
          // );
          final Widget child = state.completedWidget;

          late ImageSwiperItem swiperItem;
          int index = 0;
          final List<ImageSwiperItem> swiperItems = [];

          if (swiperImageSrcs != null) {
            for (int i = 0; i < swiperImageSrcs!.length; i++) {
              final SuperImageSource src = swiperImageSrcs![i];

              final ImageSwiperItem item = ImageSwiperItem(src);

              if (src.path == imageSrc.path || src.url == imageSrc.url) {
                swiperItem = item;
                index = i;
              }

              swiperItems.add(item);
            }
          } else {
            swiperItem = ImageSwiperItem(imageSrc);
            swiperItems.add(swiperItem);
          }

          result = GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                TransparentPageRoute<void>(
                  builder: (BuildContext context) => ImageViewer(
                    index: index,
                    swiperItems: swiperItems,
                  ),
                ),
              );
            },
            child: Hero(
              tag: swiperItem.heroTag,
              // since we have box.fit cover, we had to customize this
              flightShuttleBuilder: (
                BuildContext flightContext,
                Animation<double> animation,
                HeroFlightDirection flightDirection,
                BuildContext fromHeroContext,
                BuildContext toHeroContext,
              ) {
                final Hero hero = flightDirection != HeroFlightDirection.push
                    ? fromHeroContext.widget as Hero
                    : toHeroContext.widget as Hero;

                return hero.child;
              },
              child: child,
            ),
          );
        }

        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (imageSrc.isFileImage) {
      return ExtendedImage.file(
        File(imageSrc.path!),
        width: width,
        height: height,
        fit: fit,
        loadStateChanged: (state) => _loadStateChanged(context, state),
      );
    } else if (imageSrc.isNetworkImage) {
      if (imageSrc.url!.isAssetUrl) {
        return ExtendedImage.asset(
          imageSrc.url!,
          width: width,
          fit: fit,
          loadStateChanged: (state) => _loadStateChanged(context, state),
        );
      }

      return ExtendedImage.network(
        imageSrc.url!,
        width: width,
        fit: fit,
        loadStateChanged: (state) => _loadStateChanged(context, state),
      );
    } else if (imageSrc.isMemoryImage) {
      return ExtendedImage.memory(
        imageSrc.memory!,
        width: width,
        fit: fit,
        loadStateChanged: (state) => _loadStateChanged(context, state),
      );
    }

    return NothingWidget();
  }
}
