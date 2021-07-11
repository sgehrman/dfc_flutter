import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/extensions/string_ext.dart';

class FormParam {
  FormParam({
    required this.formData,
    required this.builderParams,
    required this.mapKey,
  });

  final Map<String, dynamic> formData;
  final FormBuilderParams builderParams;

  String mapKey;
  Type type = String;
  bool req = false;
  bool hide = false;
  bool separateLabel = false;
  TextInputType keyboard = TextInputType.text;

  int? minLines;
  int? maxLines;
  bool enableSuggestions = false;
  bool autocorrect = false;

  void setLines(int min) {
    minLines = min;
    maxLines = min * 4;
  }

  Widget? createWidget() {
    return builderParams.createWidget(mapKey);
  }

  String? label() {
    final label = formData['$mapKey-label'] as String?;

    if (Utils.isNotEmpty(label)) {
      return label;
    }

    return mapKey.fromCamelCase();
  }
}

class FormBuilderParams extends ChangeNotifier {
  FormBuilderParams({
    required this.map,
    this.saveNotifier,
  }) {
    widgetKeys().forEach((mapKey) {
      formParams[mapKey] =
          FormParam(formData: map, builderParams: this, mapKey: mapKey);
    });
  }

  Map<String, FormParam> formParams = {};
  final Map<String, dynamic> map;
  ValueNotifier<bool>? saveNotifier;

  Widget? createWidget(String key) {
    return null;
  }

  // override this to change order
  // call super to get default keys
  List<String> widgetKeys() {
    return map.keys.toList();
  }

  void filter() {
    widgetKeys().forEach((key) {
      switch (key) {
        case 'id':
        case 'userId':
          formParams[key]!.hide = true;
          break;
        case 'name':
          formParams[key]!.req = true;

          formParams[key]!.enableSuggestions = true;
          formParams[key]!.autocorrect = true;
          break;
        case 'notes':
        case 'description':
        case 'bio':
        case 'text':
        case 'question':
          formParams[key]!.setLines(3);

          formParams[key]!.enableSuggestions = true;
          formParams[key]!.autocorrect = true;

          // multiline allows newlines
          formParams[key]!.keyboard = TextInputType.multiline;
          break;
        case 'email':
          // formParams[key].req = true;
          formParams[key]!.keyboard = TextInputType.emailAddress;
          break;
        case 'phone':
          // formParams[key].req = true;
          formParams[key]!.keyboard = TextInputType.phone;
          break;
        case 'address':
          formParams[key]!.keyboard = TextInputType.streetAddress;
          break;
        default:
          break;
      }
    });
  }
}
