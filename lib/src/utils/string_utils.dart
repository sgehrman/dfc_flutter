import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hex/hex.dart';

class StrUtils {
  static void print(String output) {
    debugPrint(output, wrapWidth: 555);
  }

  static String toPrettyString(Map map, {bool print = false}) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String prettyprint = encoder.convert(map);

    if (print) {
      debugPrint(prettyprint, wrapWidth: 555);
    }

    return prettyprint;
  }

  static String toPrettyList(List<Map> list, {bool print = false}) {
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
}
