import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/utils/string_utils.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/form_builder/form_params.dart';
import 'package:dfc_flutter/src/widgets/phone_input_utils.dart';
import 'package:flutter/material.dart';

class FieldBuilder {
  static List<Widget> fields({
    required BuildContext context,
    required FormBuilderParams builderParams,
    required bool autovalidate,
    bool outlinedBorders = false,
  }) {
    final List<Widget> result = [];

    builderParams.widgetKeys().forEach((mapKey) {
      final formParams = builderParams.formParams;

      if (!formParams[mapKey]!.hide) {
        if (formParams[mapKey]!.type == String) {
          final formParam = formParams[mapKey]!;

          if (formParam.separateLabel) {
            result.add(Text(formParam.label()!));
          }

          result.add(
            stringField(
              context: context,
              mapKey: mapKey,
              formParam: formParam,
              autovalidate: autovalidate,
              outlinedBorders: outlinedBorders,
            ),
          );
        } else {
          final Widget? customWidget = formParams[mapKey]!.createWidget();
          if (customWidget != null) {
            result.add(customWidget);
          }
        }
      }
    });

    return result;
  }

  static Widget stringField({
    required BuildContext context,
    required String mapKey,
    required FormParam formParam,
    required bool autovalidate,
    bool outlinedBorders = false,
  }) {
    final border = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color:
                  Utils.isDarkMode(context) ? Colors.white10 : Colors.black12,
            ),
          )
        : null;

    final focusedBorder = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              color:
                  Utils.isDarkMode(context) ? Colors.white54 : Colors.black45,
            ),
          )
        : null;

    final errorBorder = outlinedBorders
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.red[300]!),
          )
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: outlinedBorders ? 16 : 10),
      child: TextFormField(
        textCapitalization: (mapKey != 'email' && mapKey != 'password')
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        keyboardType: formParam.keyboard,
        textInputAction: (formParam.maxLines == null || formParam.maxLines == 1)
            ? TextInputAction.next
            : TextInputAction.done,
        autovalidateMode:
            autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        initialValue: formParam.formData[mapKey] as String?,
        minLines: formParam.minLines,
        maxLines: formParam.maxLines,
        autocorrect: formParam.autocorrect,
        enableSuggestions: formParam.enableSuggestions,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          labelText: formParam.separateLabel ? null : formParam.label(),

          // placeholder
          // hintText: mapKey.capitalize,

          // text below
          // helperText: mapKey.capitalize,
        ),
        inputFormatters:
            mapKey == 'phone' ? PhoneInputUtils.inputFormatters() : null,
        validator: (v) {
          if (formParam.req) {
            if (Utils.isEmpty(v)) {
              return 'Please enter ${mapKey.fromCamelCase()}';
            }
          }

          if (mapKey == 'phone' && Utils.isNotEmpty(v)) {
            return PhoneInputUtils.validator(v);
          }

          if (mapKey == 'email' && Utils.isNotEmpty(v)) {
            if (!StrUtils.isEmailValid(v)) {
              return 'Email invalid';
            }
          }

          return null;
        },
        onSaved: (String? v) {
          formParam.formData[mapKey] = v!.trim();
        },
      ),
    );
  }
}
