import 'package:dfc_flutter/src/web_utils/web_utils_interface.dart';
import 'package:dfc_flutter/src/web_utils/web_utils_stub.dart'
    if (dart.library.js_interop) 'package:dfc_flutter/src/web_utils/web_utils_js.dart'
    if (dart.library.io) 'package:dfc_flutter/src/web_utils/web_utils_io.dart';

class WebUtils {
  factory WebUtils() {
    return _instance ??= WebUtils._();
  }

  WebUtils._();
  static WebUtils? _instance;
  final WebUtilsInterface _ba = WebUtilsImp();

  bool isChrome() {
    return _ba.isChrome();
  }

  bool isSafari() {
    return _ba.isSafari();
  }

  bool isFireFox() {
    return _ba.isFireFox();
  }

  bool isFullscreen() {
    return _ba.isFullscreen();
  }
}
