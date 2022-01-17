import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneInputUtils {
  static List<TextInputFormatter> inputFormatters() {
    return <TextInputFormatter>[
      // TextInputFormatter.withFunction(
      //     (TextEditingValue oldValue, TextEditingValue newValue) {
      //   String newText = newValue.text;

      //   TextSelection selection = newValue.selection;

      //   if (Utils.isNotEmpty(newText)) {
      //     if (newText[0] != '+') {
      //       newText = '+1$newText';

      //       selection = TextSelection.collapsed(offset: newText.length);
      //     }
      //   }

      //   return newValue.copyWith(
      //     text: newText,
      //     selection: selection,
      //   );
      // }),
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
