import 'dart:async';
import 'dart:convert';

import 'package:dfc_flutter/src/http/http_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Utf8Utils {
  Utf8Utils._();

  static Future<String> decodeUtf8(
    http.Response response,
  ) async {
    if (HttpUtils.statusOK(response.statusCode)) {
      String? decoded;

      // this fails
      // https://tass.com/rss/v2.xml
      // https://github.com/dart-lang/http/issues/180

      // nytimes uses weird quotes that are utf8, but the file doesn't specify utf-8
      // so by default it uses latin1 for body and fails, so we have to besure to decode utf-8

      // one feed on CNN crashes with utf8, but works on latin1?

      // try the utf8 first, japanese broken with response.body? http://rss.asahi.com/rss/asahi/newsheadlines.rdf
      decoded = await _decodeUtf8Async(response.bodyBytes);

      // if fails, get the body as normal
      if (decoded == null) {
        try {
          print('Utf8Utils: response.body');

          decoded = response.body;
        } catch (e) {
          // print('Utf8Utils: response.body failed: $e');
        }
      }

      // if fails, allowMalformed: true
      // uherd.com/feed was failing
      // FormatException: Unexpected extension byte (at offset 15031)
      if (decoded == null) {
        print('Utf8Utils: malformed');

        decoded = await _decodeUtf8Async(
          response.bodyBytes,
          allowMalformed: true,
        );
      }

      if (decoded != null) {
        return decoded;
      }
    }

    print('Utf8Utils: decodeUtf8 totally failed');

    return '';
  }

  static String? _utf8ComputeFunc(Map<String, dynamic> params) {
    final bytes = params['bytes'] as Uint8List?;
    final allowMalformed = params['allowMalformed'] as bool? ?? false;

    print('Utf8Utils: using compute encoding');

    if (bytes != null) {
      return _decodeUtf8(
        bytes,
        allowMalformed: allowMalformed,
      );
    } else {
      print('Utf8Utils: _utf8ComputeFunc bytes == null');
    }

    return null;
  }

  static Future<String?> _decodeUtf8Async(
    Uint8List bytes, {
    bool allowMalformed = false,
  }) async {
    // utf8.decode can hang the thread if large.
    // push off to a isolate if large enough
    // the idea is our server can handle incoming requests faster if
    // the main thread is not hung on this
    if (bytes.length > 200 * 1024) {
      final params = {
        'bytes': bytes,
        'allowMalformed': allowMalformed,
      };

      return compute<Map<String, dynamic>, String?>(_utf8ComputeFunc, params);
    }

    return _decodeUtf8(
      bytes,
      allowMalformed: allowMalformed,
    );
  }

  static String? _decodeUtf8(
    Uint8List bytes, {
    bool allowMalformed = false,
  }) {
    try {
      return utf8.decode(
        bytes,
        allowMalformed: allowMalformed,
      );
    } catch (err) {
      // print('Utf8Utils: utf8.decode failed: $err');
    }

    return null;
  }
}
