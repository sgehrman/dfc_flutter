import 'package:dfc_flutter/src/web_utils/browser_detect.dart';
import 'package:dfc_flutter/src/web_utils/web_utils_interface.dart';

class WebUtilsImp implements WebUtilsInterface {
  @override
  bool isChrome() {
    return BrowserDetect().isChrome();
  }

  @override
  bool isSafari() {
    return BrowserDetect().isSafari();
  }

  @override
  bool isFireFox() {
    return BrowserDetect().isFireFox();
  }
}