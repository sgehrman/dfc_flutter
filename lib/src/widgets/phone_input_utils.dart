import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

class PhoneInputUtils {
  static List<TextInputFormatter> inputFormatters() {
    return <TextInputFormatter>[
      // forces the first character to be 1 for country code
      TextInputFormatter.withFunction(
          (TextEditingValue oldValue, TextEditingValue newValue) {
        String newText = newValue.text;

        TextSelection selection = newValue.selection;

        if (Utils.isNotEmpty(newText) && newText.length == 1) {
          if (newText[0] != '1' && newText[0] != '+') {
            newText = '1$newText';

            selection = TextSelection.collapsed(offset: selection.end + 1);
          }
        }

        return newValue.copyWith(
          text: newText,
          selection: selection,
        );
      }),
      PhoneInputFormatter(
        onCountrySelected: (PhoneCountryData? countryData) =>
            print(countryData?.country),
      ),
    ];
  }

  static String? validator(String? value) {
    if (value != null) {
      if (!isPhoneValid(value)) {
        return 'Phone is invalid';
      }
    }

    return null;
  }
}
