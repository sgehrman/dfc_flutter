import 'package:flutter/material.dart';

class DFInputDecoration {
  static InputDecoration decoration({
    EdgeInsets? contentPadding,
    String? hintText,
    String? labelText,
    Widget? prefix,
    Widget? suffix,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? icon,
    Color? prefixIconColor,
    Color? suffixIconColor,
    int? hintMaxLines,
    Widget? label,
    BoxConstraints? prefixIconConstraints,
    BoxConstraints? suffixIconConstraints,
    String? errorText,
  }) {
    var isDense = false;

    // only make dense has some icons, otherwise it will look weird
    if (suffixIcon != null || prefixIcon != null) {
      isDense = true;
    }

    return InputDecoration(
      helperMaxLines: 1,
      contentPadding: contentPadding,
      isDense: isDense,
      labelText: labelText?.isNotEmpty ?? false ? labelText : null,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      icon: icon,
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,
      hintMaxLines: hintMaxLines,
      label: label,
      suffix: suffix,
      prefix: prefix,
      prefixIconConstraints: prefixIconConstraints,
      suffixIconConstraints: suffixIconConstraints,
      errorText: errorText,
    );
  }
}
