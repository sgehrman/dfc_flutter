import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// ========================================================
//
//   To translate all the files, run this
//
//   $ dart ./translator_tool.dart
//
//   or
//
//   $ ./tools/translate - from the root
//
// ========================================================

void main() {
  Translator.start();
}

const arbDirPath = './arb';

class Translator {
  static Future<void> start() async {
    final englishMap = _arbMap('en');

    const encoder = JsonEncoder.withIndent('  ');

    final languageCodes = [
      // 'en',
      'ja',
      'es',
      'de',
      'fr',
      'it',
      'zh',
      'cs',
      'da',
      'fi',
      'nl',
      'ru',
      'sv',
    ];

    for (final languageCode in languageCodes) {
      // make a copy
      final sourceMapCopy = Map<String, dynamic>.of(englishMap);

      final existingMap = _arbMap(languageCode);

      for (final item in sourceMapCopy.entries) {
        if (item.key == '@@locale') {
          // fill in languageCode, it's 'en' since starting with english file
          sourceMapCopy[item.key] = languageCode;
        } else if (item.key.startsWith('@')) {
          // sourceMapCopy already copied above, just skip
          // sourceMapCopy[item.key] = englishMap[item.key] ?? '';
        } else {
          if (item.value is String) {
            final existing = existingMap[item.key] ?? '';

            // don't translate if already translated
            if (existing is String &&
                existing.isNotEmpty &&
                englishMap[item.key] != existing) {
              sourceMapCopy[item.key] = existing;
            } else {
              sourceMapCopy[item.key] = await _translate(
                item.value as String,
                languageCode,
              );
            }
          } else {
            // startswith @ above should catch everyting, but warn here since it would unexpected
            print('Translator item not handled: $item');
          }
        }
      }

      final destName = 'app_$languageCode.arb';
      final destFile = File('$arbDirPath/$destName');

      if (!destFile.existsSync()) {
        destFile.createSync(recursive: true);
      }

      print('Saving: ${destFile.path}');
      destFile.writeAsStringSync('${encoder.convert(sourceMapCopy)}\n');
    }
  }

  static Map<String, dynamic> _arbMap(String languageCode) {
    final filename = 'app_$languageCode.arb';
    final file = File('$arbDirPath/$filename');

    if (file.existsSync()) {
      final jsonString = file.readAsStringSync();

      if (jsonString.isNotEmpty) {
        return Map<String, dynamic>.from(json.decode(jsonString) as Map);
      }
    }

    return {};
  }

  static Future<String> _translate(String text, String languageCode) async {
    // skip english
    if (languageCode == 'en') {
      return text;
    }

    print('$languageCode: translating => $text');

    // final uri = Uri.parse('https://api-free.deepl.com/v2/translate');
    final uri = Uri.parse('https://api.deepl.com/v2/translate');

    final processedInput = ProcessedInput.process(text);

    final body = <String, String>{
      'text': processedInput.processed,
      'auth_key': 'xxxxxxxxxxxx',
      'target_lang': languageCode,
      'source_lang': 'en',
      'format': 'text',
      'formality': 'prefer_less',
    };

    try {
      final result = await _getTranslationRetry(uri, body);

      final results = result['translations'] as List?;

      if (results != null && results.isNotEmpty) {
        final m = results.first as Map;
        final text = m['text'] as String;

        return processedInput.restore(text);
      } else {
        print(result);
      }
    } catch (err) {
      print(err);
    }

    print('Failed ($languageCode): $text');

    return text;
  }
}

// ======================================================

Future<Map<String, dynamic>> _getTranslationRetry(
  Uri uri,
  Map<String, String> body,
) async {
  try {
    while (true) {
      final res = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
        },
        body: body,
      );

      if (res.bodyBytes.isNotEmpty) {
        final bodyString = utf8.decode(res.bodyBytes);

        if (bodyString.startsWith('<')) {
          // <html>
          // <head><title>429 Too Many Requests</title></head>
          // <body>
          // <center><h1>429 Too Many Requests</h1></center>
          // <hr><center>nginx</center>
          // </body>
          // </html>
          print('Waiting to try again...');

          await Future.delayed(const Duration(seconds: 2));
          print('Retrying...');
        } else {
          return Map<String, dynamic>.from(json.decode(bodyString) as Map);
        }
      } else {
        print('body empty');
      }
    }
  } catch (err) {
    print('getTranslationRetry catch: $err');
  }

  print('getTranslationRetry failed');

  return {};
}

// ======================================================

class ProcessedInput {
  ProcessedInput({
    required this.original,
    required this.parameter,
    required this.processed,
    required this.hasEllipsis,
  });

  final String original;
  final String processed;
  final String parameter;
  final bool hasEllipsis;

  static const String _deckrReplacement = 'N666555';
  static const String _pathFinderReplacement = 'N626535';
  static const String _paramReplacement = 'P888777';

  // =============================================================
  // static helpers

  // ignore: prefer_constructors_over_static_methods
  static ProcessedInput process(String original) {
    var copied = original.replaceAll('Deckr', _deckrReplacement);
    copied = original.replaceAll('Path Finder', _pathFinderReplacement);

    final hasEllipsis = copied.endsWith('…');

    if (hasEllipsis) {
      copied = copied.replaceAll('…', '');
    }

    var parameter = '';

    // replace any {}
    if (copied.contains('{') && copied.contains('}')) {
      final frontSplit = copied.split('{');

      if (frontSplit.length == 2) {
        final endSplit = frontSplit.last.split('}');

        if (endSplit.isNotEmpty) {
          parameter = '{${endSplit.first}}';

          if (parameter.isNotEmpty) {
            copied = copied.replaceAll(parameter, _paramReplacement);
          }
        }
      }
    }

    return ProcessedInput(
      original: original,
      parameter: parameter,
      processed: copied,
      hasEllipsis: hasEllipsis,
    );
  }

  String restore(String translated) {
    var result = translated.replaceAll(_deckrReplacement, 'Deckr');
    result = translated.replaceAll(_pathFinderReplacement, 'Path Finder');

    if (parameter.isNotEmpty) {
      result = result.replaceAll(_paramReplacement, parameter);
    }

    if (hasEllipsis) {
      result = '$result…';
    }

    return result;
  }
}
