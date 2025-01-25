import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dfc_dart/dfc_dart.dart';
import 'package:dfc_flutter/src/http/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as img;

export 'package:vector_graphics/vector_graphics.dart';

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

const int minImageSize = 80;
const int maxWidthScreenshot = 512;
const int maxWidthIcon = 256;

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

  static Future<PngImageBytesAndSize> pngFromBytes(Uint8List imageData) async {
    try {
      // could be any format so convert to png
      final decodedImage = await bytesToImage(imageData);

      // draws image to a canvas
      final ui.Image pictureImage = await _drawImageToCanvas(decodedImage);

      // must dispose
      decodedImage.dispose();

      // convert to png byte data
      final ByteData? pngData = await pictureImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      // copy before we dispose the picture image
      final int height = pictureImage.height;
      final int width = pictureImage.width;

      // must dispose
      pictureImage.dispose();

      if (pngData != null) {
        final bs = pngData.buffer.asUint8List();

        return PngImageBytesAndSize(
          bytes: bs,
          height: height,
          width: width,
        );
      }
    } catch (err) {
      print(err);
    }

    return PngImageBytesAndSize(
      bytes: Uint8List(0),
      height: 0,
      width: 0,
    );
  }

  static bool isSvg({
    required Uri uri,
    required Uint8List bytes,
  }) {
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

  static Future<PngImageBytesAndSize> downloadImageToPng(Uri uri) async {
    try {
      if (UriUtils.isDataUri(uri)) {
        final dUri = UriData.fromUri(uri);

        final bodyBytes = dUri.contentAsBytes();

        if (bodyBytes.isNotEmpty) {
          return pngFromBytes(bodyBytes);
        }
      } else {
        final response = await HttpUtils.httpGet(uri, timeout: 60);

        if (HttpUtils.statusOK(response.statusCode)) {
          final Uint8List bodyBytes = response.bodyBytes;

          if (bodyBytes.isNotEmpty) {
            if (isSvg(uri: uri, bytes: bodyBytes)) {
              final svgString = utf8.decode(bodyBytes);

              return svgToPng(svg: svgString);
            } else {
              return pngFromBytes(bodyBytes);
            }
          }
        }
      }
    } catch (e) {
      print('### downloadImageToPng error: $e\nuri: $uri');
    }

    return PngImageBytesAndSize(
      bytes: Uint8List(0),
      height: 0,
      width: 0,
    );
  }

  static Future<void> processAndSaveImage({
    required Uint8List imageData,
    required int imageWidth,
    required ImgFormat dataFormat,
    required int maxWidth,
    required ImgFormat saveFormat,
    required String savePath,
  }) async {
    try {
      final cmd = img.Command();

      await _appendConvertAndResize(
        cmd: cmd,
        imageData: imageData,
        dataFormat: dataFormat,
        imageWidth: imageWidth,
        maxWidth: maxWidth,
        saveFormat: saveFormat,
      );

      cmd.writeToFile(savePath);

      await cmd.execute();
    } catch (err) {
      print(
        'ImageProcessor: $err - format: ${dataFormat.name} path: $savePath',
      );
    }
  }

  static Future<void> _appendConvertAndResize({
    required img.Command cmd,
    required Uint8List imageData,
    required ImgFormat dataFormat,
    required int imageWidth,
    required int maxWidth,
    required ImgFormat saveFormat,
  }) async {
    switch (dataFormat) {
      case ImgFormat.unknown:
      case ImgFormat.cur:
        cmd.decodeImage(imageData);
        break;
      case ImgFormat.png:
        cmd.decodePng(imageData);
        break;
      case ImgFormat.jpg:
        cmd.decodeJpg(imageData);
        break;
      case ImgFormat.webp:
        cmd.decodeWebP(imageData);
        break;
      case ImgFormat.svg:
        final svgString = utf8.decode(imageData);
        final pngResult = await svgToPng(svg: svgString);
        cmd.decodePng(pngResult.bytes);
        break;
      case ImgFormat.gif:
        cmd.decodeGif(imageData);
        break;
      case ImgFormat.tiff:
        cmd.decodeTiff(imageData);
        break;
      case ImgFormat.ico:
        cmd.decodeIco(imageData);
        break;
      case ImgFormat.bmp:
        cmd.decodeBmp(imageData);
        break;
      case ImgFormat.tga:
        cmd.decodeTga(imageData);
        break;
      case ImgFormat.pvr:
        cmd.decodePvr(imageData);
        break;
    }

    if (dataFormat != saveFormat) {
      switch (saveFormat) {
        case ImgFormat.unknown:
        case ImgFormat.cur:
        case ImgFormat.svg:
        case ImgFormat.webp:
        case ImgFormat.png:
          cmd.encodePng(level: 5);
          break;
        case ImgFormat.jpg:
          cmd.encodeJpg(quality: 60);
          break;
        case ImgFormat.gif:
          cmd.encodeGif();
          break;
        case ImgFormat.tiff:
          cmd.encodeTiff();
          break;
        case ImgFormat.ico:
          cmd.encodeIco();
          break;
        case ImgFormat.bmp:
          cmd.encodeBmp();
          break;
        case ImgFormat.tga:
          cmd.encodeTga();
          break;
        case ImgFormat.pvr:
          cmd.encodePvr();
          break;
      }
    }

    if (imageWidth > maxWidth) {
      cmd.copyResize(
        width: maxWidth,
        interpolation: img.Interpolation.average,
      );
    }
  }

  // ===============================================================

  static BoxFit _fitForImage(ui.Image image) {
    final imageSize = ui.Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    BoxFit fit = BoxFit.cover;

    // not a square, use contain if wider than tall
    // could be a wide logo for example (revolver.news)
    if (imageSize.width > imageSize.height) {
      if (imageSize.shortestSide / imageSize.longestSide < 0.8) {
        fit = BoxFit.contain;
      }
    }

    return fit;
  }

  static Future<PngImageBytesAndSize> svgToPng({
    required String svg,
    int width = 0, // pass zero to use Size in png
    Color? color,
  }) async {
    try {
      final PictureInfo pictureInfo = await vg.loadPicture(
        SvgStringLoader(
          svg,
          theme: SvgTheme(
            currentColor: color ?? Colors.black,
          ),
        ),
        null,
        onError: (error, stackTrace) {
          print('vg.loadPicture error: $error');
        },
      );

      final imageWidth = pictureInfo.size.width.ceil();
      final imageHeight = pictureInfo.size.height.ceil();

      ui.Image image = await pictureInfo.picture.toImage(
        imageWidth,
        imageHeight,
      );
      pictureInfo.picture.dispose();

      if (width != 0) {
        final disposeAfter = image;

        image = await _resizeImage(
          image: image,
          height: width.toDouble(),
          width: width.toDouble(),
          fit: _fitForImage(image),
        );

        disposeAfter.dispose();
      }

      final ByteData? bd = await image.toByteData(
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
      print('svgToPng: Error = $err');
    }

    return PngImageBytesAndSize(
      bytes: Uint8List(0),
      height: 0,
      width: 0,
    );
  }

  // ========================================================================================

  // ## must dispose
  static Future<ui.Image> bytesToImage(Uint8List bytes) async {
    final ui.ImmutableBuffer buffer =
        await ui.ImmutableBuffer.fromUint8List(bytes);
    final ui.ImageDescriptor descriptor =
        await ui.ImageDescriptor.encoded(buffer);

    // descriptor.width
    // descriptor.height

    final ui.Codec codec = await descriptor.instantiateCodec(
        // use this if you don't use the svg replacement (facebook thing?)
        // targetWidth: _kWidth.toInt(),
        // targetHeight: _kWidth.toInt(),
        );

    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    // not sure if this is necessary or even a good idea, but saw it in some flutter code
    buffer.dispose();
    codec.dispose();
    descriptor.dispose();

    return frameInfo.image;
  }

  // ## must dispose
  // doesn't work on web. never tested, not sure if this works
  static Future<ui.Image> assetImage(String assetPath) async {
    final ui.ImmutableBuffer buffer =
        await ui.ImmutableBuffer.fromAsset(assetPath);
    final ui.ImageDescriptor descriptor =
        await ui.ImageDescriptor.encoded(buffer);

    final ui.Codec codec = await descriptor.instantiateCodec(
      targetWidth: descriptor.width,
      targetHeight: descriptor.height,
    );

    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    buffer.dispose();
    codec.dispose();
    descriptor.dispose();

    return frameInfo.image;
  }

  // ===============================================================

  static Future<ui.Image> _drawImageToCanvas(
    ui.Image image,
  ) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.save();
    double scale = 1;

    // we don't want super small favicons for example, make them at least minImageSize
    final imageSize = math.min(image.width, image.height);
    if (imageSize < minImageSize) {
      scale = minImageSize / imageSize;
      scale = math.min(scale, 50);

      canvas.scale(scale);
    }

    canvas.drawImage(image, ui.Offset.zero, ui.Paint());

    canvas.restore();

    final picture = recorder.endRecording();

    // get image fom picture and get the png data
    // await so we don't dispose() before done
    final result = await picture.toImage(
      (image.width * scale).ceil(),
      (image.height * scale).ceil(),
    );

    picture.dispose();

    return result;
  }

  static Future<ui.Image> _resizeImage({
    required ui.Image image,
    required double height,
    required double width,
    BoxFit fit = BoxFit.scaleDown,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, width, height),
      image: image,
      fit: fit,
      isAntiAlias: true,
      filterQuality: FilterQuality.high,
    );

    final picture = recorder.endRecording();

    final result = await picture.toImage(
      width.ceil(),
      height.ceil(),
    );

    picture.dispose();

    return result;
  }

  static Future<PngImageBytesAndSize> imageToSquarePng(
    Uri uri,
    int size,
  ) async {
    Uint8List imageBytes = Uint8List(0);

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

      // resize to square
      if (imageBytes.isNotEmpty) {
        // could be any format so convert to png
        final decodedImage = await bytesToImage(imageBytes);

        final image = await _resizeImage(
          image: decodedImage,
          height: size.toDouble(),
          width: size.toDouble(),
          fit: _fitForImage(decodedImage),
        );

        decodedImage.dispose();

        final ByteData? bd = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );

        // must dispose
        image.dispose();

        if (bd != null) {
          final bytes = bd.buffer.asUint8List();

          return PngImageBytesAndSize(
            bytes: bytes,
            height: size,
            width: size,
          );
        }
      }
    } catch (e) {
      print('### downloadImageToPng error: $e\nuri: $uri');
    }

    return PngImageBytesAndSize(
      bytes: Uint8List(0),
      height: 0,
      width: 0,
    );
  }
}
