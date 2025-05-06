import 'package:dfc_flutter/src/utils/string_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

extension StringUtils on String {
  bool get isAssetUrl {
    return startsWith('assets/');
  }

  String get firstChar {
    if (Utils.isNotEmpty(this)) {
      return substring(0, 1);
    }

    return '';
  }

  String get capitalize {
    if (Utils.isEmpty(this)) {
      return this;
    }

    return this[0].toUpperCase() + substring(1);
  }

  String fromCamelCase() {
    var displayName = '';
    var lastUpper = false;

    final characters = split('');
    for (final r in characters) {
      if (r.toUpperCase() == r) {
        displayName += lastUpper ? r : ' $r';

        lastUpper = true;
      } else {
        lastUpper = false;

        if (displayName.isEmpty) {
          displayName += r.toUpperCase();
        } else {
          displayName += r;
        }
      }
    }

    return displayName;
  }

  String truncate([int max = 20]) {
    var result = this;

    if (Utils.isNotEmpty(result)) {
      if (result.length > max) {
        // we trim to get rid of newlines at end
        result = '${result.substring(0, max).trim()}...';
      }
    }

    return result;
  }

  String preTruncate([int max = 20]) {
    var result = this;

    if (Utils.isNotEmpty(result)) {
      if (result.length > max) {
        // we trim to get rid of newlines at end
        result =
            '...${result.substring(result.length - max, result.length).trim()}';
      }
    }

    return result;
  }

  String removeTrailing(String trailing) {
    // don't remove last '/' if path is '/'
    if (this != trailing) {
      if (Utils.isNotEmpty(trailing)) {
        if (endsWith(trailing)) {
          return substring(0, length - trailing.length);
        }
      }
    }

    return this;
  }

  String removePrefix(String prefix) {
    // don't remove last '/' if path is '/'
    if (this != prefix) {
      if (Utils.isNotEmpty(prefix)) {
        if (startsWith(prefix)) {
          return substring(prefix.length);
        }
      }
    }

    return this;
  }

  String get convertHtmlCodes {
    return StrUtils.convertHtmlCodes(this);
  }

  String superTrim() {
    // remove spaces after newline
    var result = replaceAll(RegExp(r'\n\s+'), '\n');

    // replace 3 or more newlines with 2 newlines
    result = result.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // two or more spaces to one space
    result = result.replaceAll(RegExp(' {2,}'), ' ');

    return result.trim();
  }
}
