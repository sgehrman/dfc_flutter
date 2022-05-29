import 'dart:typed_data';

import 'package:flutter/material.dart';

class FadeImage extends StatelessWidget {
  const FadeImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.missingImage,
    Key? key,
  }) : super(key: key);

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? missingImage;

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      imageErrorBuilder: (context, error, stackTrace) {
        return SizedBox(height: height, width: width, child: missingImage);
      },
      placeholder: _transparentImage,
      image: url,
      fadeInDuration: const Duration(milliseconds: 400),
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

// =================================================================

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
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
