import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dfc_dart/dfc_dart.dart';
import 'package:dfc_flutter/src/http/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImgFormat {
  unknown,
  png,
  jpg,
  webp,
  svg,
  gif,
  tiff,
  ico,
  bmp,
  tga,
  cur,
  pvr,
}

class PngImageBytesAndSize {
  const PngImageBytesAndSize({
    required this.bytes,
    required this.height,
    required this.width,
  });

  final Uint8List bytes;
  final int height;
  final int width;
}

class ImageProcessor {
  static ImgFormat formatForName(String name) {
    final n = name.toLowerCase();
    if (n.endsWith('.jpg') || n.endsWith('.jpeg')) {
      return ImgFormat.jpg;
    } else if (n.endsWith('.png')) {
      return ImgFormat.png;
    } else if (n.endsWith('.tga')) {
      return ImgFormat.tga;
    } else if (n.endsWith('.gif')) {
      return ImgFormat.gif;
    } else if (n.endsWith('.tif') || n.endsWith('.tiff')) {
      return ImgFormat.tiff;
    } else if (n.endsWith('.bmp')) {
      return ImgFormat.bmp;
    } else if (n.endsWith('.ico')) {
      return ImgFormat.ico;
    } else if (n.endsWith('.cur')) {
      return ImgFormat.cur;
    } else if (n.endsWith('.pvr')) {
      return ImgFormat.pvr;
    } else if (n.endsWith('.svg')) {
      return ImgFormat.svg;
    }

    // example github.com
    // https://opengraph.githubassets.com/6e72d0aa3ae8284ddee76176dce23ccf8bd57d4a0ec0febf17b9a12d6c9835ee/Mikhail-Ivanou/linkify
    // print('ImageProcessor.formatForName: unknown extension: $name');

    return ImgFormat.unknown;
  }

  static Future<PngImageBytesAndSize> pngFromBytes(
    Uint8List imageData, {
    double maxSize = 0,
  }) async {
    try {
      // could be any format so convert to png
      final decodedImage = await bytesToImage(imageData);

      // ## not sure why I did this. Could a gif or other weird format require this?
      // or does it save memory?
      final pictureImage = await _drawImageToCanvas(
        image: decodedImage,
        maxSize: maxSize,
      );

      // must dispose
      // SNG TESTING
      // decodedImage.dispose();
      print('pngFromBytes: descriptor');
      print(decodedImage.width);
      print(decodedImage.height);

      // convert to png byte data
      final pngData = await pictureImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      // copy before we dispose the picture image
      final height = pictureImage.height;
      final width = pictureImage.width;

      // SNG TESTING
      print('pictureImage');
      print(pictureImage.height);
      print(pictureImage.width);

      // must dispose
      // SNG TESTING
      //  pictureImage.dispose();

      if (pngData != null) {
        final bs = pngData.buffer.asUint8List();

        // SNG TESTING
        print('bs.lengthInBytes');
        print(bs.lengthInBytes);

        return PngImageBytesAndSize(bytes: bs, height: height, width: width);
      }
    } catch (err) {
      print(err);
    }

    return PngImageBytesAndSize(bytes: Uint8List(0), height: 0, width: 0);
  }

  static bool isSvg({required Uri uri, required Uint8List bytes}) {
    final format = ImageProcessor.formatForName(uri.path);

    if (format == ImgFormat.svg) {
      return true;
    }

    // might be an svg without a .svg extension
    if (format == ImgFormat.unknown) {
      if (bytes.length < (1024 * 100)) {
        try {
          final decoded = utf8.decode(bytes);

          if (decoded.startsWith('<svg')) {
            return true;
          }
        } catch (e) {
          // print('utf8.decode failed: $e');
        }
      }
    }

    return false;
  }

  static Future<PngImageBytesAndSize> downloadImageToPng(
    Uri uri, {
    double maxSize = 0,
  }) async {
    try {
      final imageBytes = await _imageBytesFromUrl(uri);

      if (imageBytes.isNotEmpty) {
        return pngFromBytes(imageBytes, maxSize: maxSize);
      }
    } catch (e) {
      print('### downloadImageToPng error: $e\nuri: $uri');
    }

    return PngImageBytesAndSize(bytes: Uint8List(0), height: 0, width: 0);
  }

  // ===============================================================

  static BoxFit _fitForImage(ui.Image image) {
    final imageSize = ui.Size(image.width.toDouble(), image.height.toDouble());

    var fit = BoxFit.cover;

    // not a square, use contain if wider than tall
    // could be a wide logo for example (revolver.news)
    if (imageSize.width > imageSize.height) {
      // 720 / 1280  youtube thumbnail == .56
      // 1536 × 346 revolver logo = .22
      // 1200 × 630 apple logo = .525
      if (imageSize.shortestSide / imageSize.longestSide < 0.5) {
        fit = BoxFit.contain;
      }
    }

    return fit;
  }

  static Future<PngImageBytesAndSize> svgToPng({
    required String svg,
    double size = 0, // pass zero to use Size in png
    Color? color,
  }) async {
    try {
      final image = await _svgToImage(
        svg: svg,
        color: color,
        size: size == 0 ? null : Size(size, size),
      );

      final bd = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      // get final image height/width before disposing
      final resultHeight = image.height;
      final resultWidth = image.width;

      image.dispose();

      if (bd != null) {
        final bytes = bd.buffer.asUint8List();

        return PngImageBytesAndSize(
          bytes: bytes,
          height: resultHeight,
          width: resultWidth,
        );
      }
    } catch (err) {
      print('svgToPng: Error = $err, svg: $svg');
    }

    return PngImageBytesAndSize(bytes: Uint8List(0), height: 0, width: 0);
  }

  // ========================================================================================

  // ## must dispose
  static Future<ui.Image> bytesToImage(Uint8List bytes) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      bytes,
    );
    final descriptor = await ui.ImageDescriptor.encoded(
      buffer,
    );

    // descriptor.width
    // descriptor.height

    final codec = await descriptor.instantiateCodec(
        // use this if you don't use the svg replacement (facebook thing?)
        // targetWidth: _kWidth.toInt(),
        // targetHeight: _kWidth.toInt(),
        );

    final frameInfo = await codec.getNextFrame();

    // not sure if this is necessary or even a good idea, but saw it in some flutter code
    // SNG TESTING
    // buffer.dispose();
    // codec.dispose();
    // descriptor.dispose();

    print('bytesToImage: descriptor');

    return frameInfo.image;
  }

  // ## must dispose
  // doesn't work on web. never tested, not sure if this works
  static Future<ui.Image> assetImage(String assetPath) async {
    final buffer = await ui.ImmutableBuffer.fromAsset(
      assetPath,
    );
    final descriptor = await ui.ImageDescriptor.encoded(
      buffer,
    );

    final codec = await descriptor.instantiateCodec(
      targetWidth: descriptor.width,
      targetHeight: descriptor.height,
    );

    final frameInfo = await codec.getNextFrame();

    buffer.dispose();
    codec.dispose();
    descriptor.dispose();

    return frameInfo.image;
  }

  // ===============================================================

  static Future<ui.Image> _drawImageToCanvas({
    required ui.Image image,
    double maxSize = 0,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    double scale = 1;

    if (maxSize > 0) {
      final maxImageSize = math.max(image.width, image.height);

      if (maxImageSize > maxSize) {
        scale = maxSize / maxImageSize;
      }
    }

    final imageRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble() * scale,
      image.height.toDouble() * scale,
    );

    paintImage(
      canvas: canvas,
      rect: imageRect,
      image: image,
      fit: BoxFit.scaleDown,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );

    final picture = recorder.endRecording();

    // await so we don't dispose() before done
    final result = await picture.toImage(
      imageRect.size.width.ceil(),
      imageRect.size.height.ceil(),
    );

    picture.dispose();

    return result;
  }

  static Future<ui.Image> _resizeImage({
    required ui.Image image,
    required double height,
    required double width,
    required BoxFit fit,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, width, height),
      image: image,
      fit: fit,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );

    final picture = recorder.endRecording();

    final result = await picture.toImage(width.ceil(), height.ceil());

    picture.dispose();

    return result;
  }

  static Future<ui.Image> _svgToImage({
    required String svg,
    required Color? color,
    required Size? size,
  }) async {
    final pictureInfo = await vg.loadPicture(
      SvgStringLoader(
        svg,
        theme: SvgTheme(currentColor: color ?? Colors.black),
      ),
      null,
      onError: (error, stackTrace) {
        print('vg.loadPicture error: $error');
      },
    );

    final svgSize = pictureInfo.size;

    Size destinationSize;
    if (size == null) {
      destinationSize = svgSize;

      // if no size give, don't return a super small png, it might be scaled up at some point (icon for example)
      if (destinationSize.longestSide < 64) {
        destinationSize = const Size(64, 64);
      }
    } else {
      destinationSize = size;
    }

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    double scale = 1;

    final resultSize =
        applyBoxFit(BoxFit.contain, svgSize, destinationSize).destination;

    if (resultSize.longestSide == resultSize.width) {
      scale = resultSize.width / svgSize.width;
    } else {
      scale = resultSize.height / svgSize.height;
    }

    canvas.scale(scale);

    canvas.drawPicture(pictureInfo.picture);

    final picture = recorder.endRecording();

    pictureInfo.picture.dispose();

    final result = await picture.toImage(
      resultSize.width.ceil(),
      resultSize.height.ceil(),
    );

    picture.dispose();

    return result;
  }

  static Future<Uint8List> _imageBytesFromUrl(Uri uri) async {
    var imageBytes = Uint8List(0);

    try {
      if (UriUtils.isDataUri(uri)) {
        final dUri = UriData.fromUri(uri);

        imageBytes = dUri.contentAsBytes();
      } else {
        final response = await HttpUtils.httpGet(uri, timeout: 60);

        if (HttpUtils.statusOK(response.statusCode)) {
          imageBytes = response.bodyBytes;
        }
      }

      // convert svgs to png
      if (imageBytes.isNotEmpty) {
        if (isSvg(uri: uri, bytes: imageBytes)) {
          final svgString = utf8.decode(imageBytes);

          imageBytes = (await svgToPng(svg: svgString)).bytes;
        }
      }
    } catch (e) {
      print('### _imageBytesFromUrl error: $e\nuri: $uri');
    }

    return imageBytes;
  }

  // this can crop the image with BoxFit.cover if the image is not square
  static Future<PngImageBytesAndSize> imageToSquarePng(
    Uri uri,
    double size,
  ) async {
    try {
      final imageBytes = await _imageBytesFromUrl(uri);

      // resize to square
      if (imageBytes.isNotEmpty) {
        // could be any format so convert to png
        final decodedImage = await bytesToImage(imageBytes);

        final image = await _resizeImage(
          image: decodedImage,
          height: size,
          width: size,
          fit: _fitForImage(decodedImage),
        );

        decodedImage.dispose();

        final bd = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        // must dispose
        image.dispose();

        if (bd != null) {
          final bytes = bd.buffer.asUint8List();

          return PngImageBytesAndSize(
            bytes: bytes,
            height: size.ceil(),
            width: size.ceil(),
          );
        }
      }
    } catch (e) {
      print('### imageToSquarePng error: $e\nuri: $uri');
    }

    return PngImageBytesAndSize(bytes: Uint8List(0), height: 0, width: 0);
  }
}
