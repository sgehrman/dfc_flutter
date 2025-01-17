import 'dart:typed_data';

import 'package:dfc_dart/dfc_dart.dart';
import 'package:dfc_flutter/src/menu_button_bar/contextual_menu.dart';
import 'package:dfc_flutter/src/menu_button_bar/menu_button_bar_item_data.dart';
import 'package:dfc_flutter/src/utils/image_processor.dart';
import 'package:dfc_flutter/src/widgets/checkerboard_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pasteboard/pasteboard.dart';

// =======================================================================
// util functions

List<MenuButtonBarItemData> _contextualMenuItems({
  required BuildContext context,
  required String url,
}) {
  final itemDatas = <MenuButtonBarItemData>[];

  itemDatas.add(
    MenuButtonBarItemData(
      title: 'Copy',
      action: () async {
        final uri = UriUtils.parseUri(url);

        if (uri != null) {
          final imageData = await ImageProcessor.downloadImageToPng(uri);

          // failing on WASM
          try {
            await Pasteboard.writeImage(imageData.bytes);
          } catch (err) {
            print('Pasteboard.writeImage exception');
            print(err);
          }
        }
      },
      leading: const Icon(Icons.copy),
    ),
  );

  return itemDatas;
}

String _cleanUrl(String url) {
  // some data urls have spaces?
  String cleanUrl = url;

  if (cleanUrl.startsWith('data')) {
    cleanUrl = cleanUrl.replaceAll(' ', '');
  }

  return cleanUrl;
}

// =======================================================================

class FadeImage extends StatelessWidget {
  const FadeImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.duration = const Duration(milliseconds: 300),
    this.checkerboard = false,
    this.missingImage,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final Widget? missingImage;
  final double? height;
  final double? width;
  final Duration duration;
  final bool checkerboard;

  @override
  Widget build(BuildContext context) {
    // some data urls have spaces?
    final cleanUrl = _cleanUrl(url);

    if (cleanUrl.isEmpty) {
      return _MissingImage(missingImage);
    }

    Widget image;

    // FadeInImage crashes with zero duration
    if (duration.compareTo(Duration.zero) == 0) {
      image = Image.network(
        cleanUrl,
        errorBuilder: (context, error, stackTrace) {
          return _MissingImage(missingImage);
        },
        fit: fit,
        height: height,
        width: width,
      );
    } else {
      image = FadeInImage.memoryNetwork(
        imageErrorBuilder: (context, error, stackTrace) {
          return _MissingImage(missingImage);
        },
        placeholder: transparentImage(),
        image: cleanUrl,
        fadeInDuration: duration,
        fadeOutDuration: duration,
        fit: fit,
        height: height,
        width: width,
      );
    }

    return ContextualMenu(
      buildMenu: () => _contextualMenuItems(
        context: context,
        url: cleanUrl,
      ),
      child: CheckerboardContainer(
        enabled: checkerboard,
        child: image,
      ),
    );
  }
}

// =======================================================================

class _MissingImage extends StatelessWidget {
  const _MissingImage(this.missingImage);

  final Widget? missingImage;

  @override
  Widget build(BuildContext context) {
    return missingImage ??
        const Icon(
          Icons.warning_outlined,
          size: 64,
        );
  }
}

// =======================================================================

class NoFadeImage extends StatelessWidget {
  const NoFadeImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.checkerboard = false,
    this.missingImage,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final bool checkerboard;
  final Widget? missingImage;

  @override
  Widget build(BuildContext context) {
    return FadeImage(
      url: url,
      fit: fit,
      checkerboard: checkerboard,
      duration: Duration.zero,
      height: height,
      width: width,
      key: key,
      missingImage: missingImage,
    );
  }
}

// =================================================================

class AssetImageFader extends StatelessWidget {
  const AssetImageFader(
    this.assetPath, {
    required this.size,
    this.package,
    this.duration = const Duration(milliseconds: 100),
    this.fit = BoxFit.contain,
  });

  final double size;
  final String assetPath;
  final String? package;
  final Duration duration;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image(
      width: size,
      height: size,
      fit: fit,
      image: AssetImage(
        assetPath,
        package: package,
      ),
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.dangerous, size: size, color: Colors.red);
      },
      frameBuilder: (
        BuildContext context,
        Widget child,
        int? frame,
        bool? wasSynchronouslyLoaded,
      ) {
        if ((wasSynchronouslyLoaded ?? false) || frame != null) {
          return child.animate().fadeIn(duration: duration);
        }

        return SizedBox(height: size, width: size);
      },
    );
  }
}

// =================================================================

Uint8List transparentImage() {
  return _transparentImage;
}

// variable so it only gets built once
final Uint8List _transparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x06,
  0x62,
  0x4B,
  0x47,
  0x44,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0x00,
  0xFF,
  0xA0,
  0xBD,
  0xA7,
  0x93,
  0x00,
  0x00,
  0x00,
  0x09,
  0x70,
  0x48,
  0x59,
  0x73,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x00,
  0x00,
  0x0B,
  0x13,
  0x01,
  0x00,
  0x9A,
  0x9C,
  0x18,
  0x00,
  0x00,
  0x00,
  0x07,
  0x74,
  0x49,
  0x4D,
  0x45,
  0x07,
  0xE6,
  0x03,
  0x10,
  0x17,
  0x07,
  0x1D,
  0x2E,
  0x5E,
  0x30,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x0B,
  0x49,
  0x44,
  0x41,
  0x54,
  0x08,
  0xD7,
  0x63,
  0x60,
  0x00,
  0x02,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0xE2,
  0x26,
  0x05,
  0x9B,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
