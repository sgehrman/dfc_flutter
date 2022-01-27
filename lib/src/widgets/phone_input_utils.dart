import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class PhoneInputUtils {
  static String formatPhone(String? phone) {
    String? result;

    if (Utils.isNotEmpty(phone)) {
      result = formatAsPhoneNumber(phone!);

      if (Utils.isNotEmpty(result)) {
        // result not valid? Try adding a +1 and trying again
        if (!isPhoneValid(result!)) {
          // nothing changed?
          if (phone == result) {
            // add the +1 and try that
            if (!result.startsWith('+')) {
              result = formatAsPhoneNumber('+1$phone');

              if (Utils.isNotEmpty(result) && !isPhoneValid(result!)) {
                // still not valid? just return the passed in phone
                result = phone;
              }
            }
          }
        }
      }
    }

    return result ?? '';
  }

  static List<TextInputFormatter> inputFormatters() {
    return <TextInputFormatter>[
      TextInputFormatter.withFunction(
          (TextEditingValue oldValue, TextEditingValue newValue) {
        String newText = newValue.text;

        TextSelection selection = newValue.selection;

        if (Utils.isNotEmpty(newText) && newText.length > 4) {
          if (newText[0] != '+') {
            newText = '+1$newText';

            selection = TextSelection.collapsed(offset: selection.end + 2);
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
