import 'package:dfc_flutter/src/utils/preferences.dart';

String tipString(String? message) {
  if (Preferences().disableTooltips) {
    return '';
  }

  return message ?? '';
}
