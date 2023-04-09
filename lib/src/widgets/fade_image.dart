import 'dart:typed_data';

import 'package:flutter/material.dart';

class FadeImage extends StatelessWidget {
  const FadeImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.missingImage,
    this.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? missingImage;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    // some data urls have spaces?
    String cleanUrl = url;
    if (cleanUrl.startsWith('data')) {
      cleanUrl = cleanUrl.replaceAll(' ', '');
    }

    return FadeInImage.memoryNetwork(
      imageErrorBuilder: (context, error, stackTrace) {
        if (missingImage != null) {
          if (height != null && width != null) {
            return SizedBox(height: height, width: width, child: missingImage);
          } else {
            return missingImage!;
          }
        }

        return const Icon(Icons.warning);
      },
      placeholder: transparentImage(),
      image: cleanUrl,
      fadeInDuration: duration,
      fit: fit,
      height: height,
      width: width,
      imageCacheWidth: width?.toInt(),
      imageCacheHeight: height?.toInt(),
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
