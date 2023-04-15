import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dfc_dart/dfc_dart.dart';
import 'package:dfc_flutter/src/utils/http_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:jovial_svg/jovial_svg.dart';

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

class PictureAndSize {
  const PictureAndSize({
    required this.picture,
    required this.height,
    required this.width,
  });

  final ui.Picture picture;
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

  static Future<PngImageBytesAndSize> _pngFromBytes(Uint8List imageData) async {
    try {
      // could be any format so convert to png
      final decodedImage = await _decodeBytesToImage(imageData);

      // draws image to a canvas
      final PictureAndSize pictureAndSize = _drawImageToCanvas(decodedImage);

      // must dispose
      decodedImage.dispose();

      // get image fom picture and get the png data
      final ui.Image pictureImage = await pictureAndSize.picture
          .toImage(pictureAndSize.width, pictureAndSize.height);

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
        // not sure if I need the one below or not, testing
        // final bs = pngData.buffer.asUint8List();
        final bs = pngData.buffer.asUint8List(
          pngData.offsetInBytes,
          pngData.lengthInBytes,
        );

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

  static Future<PngImageBytesAndSize> downloadImageToPng(Uri uri) async {
    try {
      if (UriUtils.isDataUri(uri)) {
        final dUri = UriData.fromUri(uri);

        final bodyBytes = dUri.contentAsBytes();

        if (bodyBytes.isNotEmpty) {
          return _pngFromBytes(bodyBytes);
        }
      } else {
        final response = await HttpUtils.httpGet(uri);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final Uint8List bodyBytes = response.bodyBytes;

          if (bodyBytes.isNotEmpty) {
            final format = ImageProcessor.formatForName(uri.path);

            if (format == ImgFormat.svg) {
              final svgString = utf8.decode(bodyBytes);

              return svgToPng(svg: svgString);
            } else {
              return _pngFromBytes(bodyBytes);
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

  static Future<PngImageBytesAndSize> svgToPng({
    required String svg,
    int width = 0, // pass zero to use Size in png
    Color? color,
  }) async {
    try {
      ScalableImage si = ScalableImage.fromSvgString(
        svg,
        // currentColor: color,
      );

      // currentColor above doesn't work?
      if (color != null) {
        si = si.modifyTint(
          newTintMode: BlendMode.srcIn,
          newTintColor: color,
        );
      }

      await si.prepareImages();

      final vpSize = si.viewport;

      final recorder = ui.PictureRecorder();
      final ui.Canvas c = ui.Canvas(recorder);

      Size size = ui.Size(vpSize.width, vpSize.height);

      if (width != 0) {
        size = ui.Size(width.toDouble(), width.toDouble());

        double h = 1;
        double w = 1;

        if (vpSize.width > vpSize.height) {
          w *= vpSize.height / vpSize.width;
        } else {
          h *= vpSize.width / vpSize.height;
        }

        c.scale(h, w);
      }

      si.paint(c);
      si.unprepareImages();

      final ui.Picture pict = recorder.endRecording();

      final ui.Image rendered =
          await pict.toImage(size.width.round(), size.height.round());

      final ByteData? bd = await rendered.toByteData(
        format: ui.ImageByteFormat.png,
      );

      pict.dispose();
      rendered.dispose();

      if (bd != null) {
        final bytes = bd.buffer.asUint8List();

        return PngImageBytesAndSize(
          bytes: bytes,
          height: size.height.toInt(),
          width: size.width.toInt(),
        );
      }
    } catch (err) {
      print('svgToPngBytes: Error = $err');
    }

    return PngImageBytesAndSize(
      bytes: Uint8List(0),
      height: 0,
      width: 0,
    );
  }

  // ========================================================================================

  // ## must dispose
  static Future<ui.Image> _decodeBytesToImage(Uint8List bytes) async {
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

  // ===============================================================

  static PictureAndSize _drawImageToCanvas(ui.Image image) {
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

    return PictureAndSize(
      picture: recorder.endRecording(),
      height: (image.height * scale).round(),
      width: (image.width * scale).round(),
    );
  }
}
