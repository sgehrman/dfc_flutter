import 'dart:convert';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hex/hex.dart';
import 'package:html/parser.dart';

class StrUtils {
  static void print(String output) {
    debugPrint(output, wrapWidth: 555);
  }

  static String toPrettyString(
    Map<dynamic, dynamic> map, {
    bool print = false,
  }) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(map);

    if (print) {
      debugPrint(prettyprint, wrapWidth: 555);
    }

    return prettyprint;
  }

  static String toPrettyList(
    List<Map<dynamic, dynamic>> list, {
    bool print = false,
  }) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(list);

    if (print) {
      debugPrint(prettyprint, wrapWidth: 555);
    }

    return prettyprint;
  }

  // returns '' if null
  static String trim(String? inString) {
    if (inString == null) {
      return '';
    }

    return inString.trim();
  }

  static bool isEmailValid(String? email) {
    final trimmedEmail = StrUtils.trim(email);

    if (trimmedEmail.isEmpty) {
      return false;
    }

    return EmailValidator.validate(trimmedEmail);
  }

  static String stringToHex(String? inString) {
    if (inString != null) {
      return hexFromData(inString.codeUnits);
    }

    return '';
  }

  static String hexToString(String? hexString) {
    if (hexString != null) {
      final charCodes = dataFromHex(hexString);

      return String.fromCharCodes(charCodes);
    }

    return '';
  }

  static String hexFromData(List<int> data) {
    return HEX.encode(data);
  }

  static List<int> dataFromHex(String hexString) {
    return HEX.decode(hexString);
  }

  static String hashStringSHA256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);

    return hexFromData(digest.bytes);
  }

  // used for displaying richText.  Long lines make it super slow
  // this breaks up huge lines if needed
  static List<String> lines(String text) {
    final lines = text.split('\n');
    final result = <String>[];
    const maxLen = 1000;

    for (final line in lines) {
      if (line.length > (maxLen + 20)) {
        // first add \n characters, then split on \n
        final StringBuffer buffer = StringBuffer();

        int offset = 0;
        while (offset < line.length) {
          final remainder = line.length - offset;

          final chunkLen = math.min(maxLen, remainder);

          buffer.writeln(
            line.substring(offset, offset + chunkLen),
          );

          offset += chunkLen;
        }

        final chunkLines = buffer.toString().split('\n');

        // ignore: prefer_foreach
        for (final cl in chunkLines) {
          result.add(cl);
        }
      } else {
        result.add(line);
      }
    }

    return result;
  }

  // there is also a string-extension
  String convertHtmlCodes(String text) {
    if (text.contains('&')) {
      try {
        return parseFragment(text).text ?? text;
      } catch (err) {
        print('html:parseFragment err: $err');
      }
    }

    return text;
  }
}
