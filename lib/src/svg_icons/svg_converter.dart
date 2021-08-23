// icons from:
// https://github.com/twbs/icons/tree/main/icons

// Regex to remove class garbage
// class=(["'])(?:(?=(\\?))\2.)*?\1

import 'dart:io';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';

Future<void> svgConvert() async {
  final List<ServerFile> result = [];

  final dir = Directory('/home/steve/expr/icons/icons');
  if (dir.existsSync()) {
    for (final file in dir.listSync()) {
      final bool isDirectory = file is Directory;

      final ServerFile serverFile = ServerFile(
        path: file.path,
        isDirectory: isDirectory,
      );

      result.add(serverFile);
    }

    final map = <String, String>{};

    for (final file in result) {
      final f = File(file.path!);

      final contents = await f.readAsString();

      final newName = file.name.replaceAll('-', '_');

      map[newName] = contents;
    }

    final outFile = File('/home/steve/expr/icons/output.dart');
    outFile.createSync();

    final List<String> names = [];

    for (final item in map.entries) {
      final nameCamel = _ReCase(item.key.removeTrailing('.svg')).camelCase;
      names.add(nameCamel);

      await outFile.writeAsString(
        "static const String $nameCamel = '${item.value.replaceAll('\n', '')}';\n\n",
        mode: FileMode.append,
      );
    }

    await outFile.writeAsString(
      '\n\n[',
      mode: FileMode.append,
    );

    for (final name in names) {
      await outFile.writeAsString(
        'SvgIcons.$name, ',
        mode: FileMode.append,
      );
    }

    await outFile.writeAsString(
      '\n\n];',
      mode: FileMode.append,
    );
  }
}

/// An instance of text to be re-cased.
class _ReCase {
  _ReCase(String text) {
    originalText = text;
    _words = _groupIntoWords(text);
  }

  final RegExp _upperAlphaRegex = RegExp('[A-Z]');

  final symbolSet = {' ', '.', '/', '_', '\\', '-'};

  late String originalText;
  late List<String> _words;

  List<String> _groupIntoWords(String text) {
    final StringBuffer sb = StringBuffer();
    final List<String> words = [];
    final bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      final String char = text[i];
      final String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      final bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  /// camelCase
  String get camelCase => _getCamelCase();

  /// CONSTANT_CASE
  String get constantCase => _getConstantCase();

  /// Sentence case
  String get sentenceCase => _getSentenceCase();

  /// snake_case
  String get snakeCase => _getSnakeCase();

  /// dot.case
  String get dotCase => _getSnakeCase(separator: '.');

  /// param-case
  String get paramCase => _getSnakeCase(separator: '-');

  /// path/case
  String get pathCase => _getSnakeCase(separator: '/');

  /// PascalCase
  String get pascalCase => _getPascalCase();

  /// Header-Case
  String get headerCase => _getPascalCase(separator: '-');

  /// Title Case
  String get titleCase => _getPascalCase(separator: ' ');

  String _getCamelCase({String separator = ''}) {
    final List<String> words = _words.map(_upperCaseFirstLetter).toList();
    if (_words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }

    return words.join(separator);
  }

  String _getConstantCase({String separator = '_'}) {
    final List<String> words =
        _words.map((word) => word.toUpperCase()).toList();

    return words.join(separator);
  }

  String _getPascalCase({String separator = ''}) {
    final List<String> words = _words.map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  String _getSentenceCase({String separator = ' '}) {
    final List<String> words =
        _words.map((word) => word.toLowerCase()).toList();
    if (_words.isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }

    return words.join(separator);
  }

  String _getSnakeCase({String separator = '_'}) {
    final List<String> words =
        _words.map((word) => word.toLowerCase()).toList();

    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}
