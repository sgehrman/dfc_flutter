import 'package:dfc_flutter/src/preferences/preferences.dart';

String tipString(String? message) {
  if (Preferences().disableTooltips) {
    return '';
  }

  return message ?? '';
}
