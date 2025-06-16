import 'package:dfc_flutter/src/web_utils/browser_detect.dart';
import 'package:dfc_flutter/src/web_utils/web_utils_interface.dart';
import 'package:web/web.dart' as web;

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

  @override
  bool isFullscreen() {
    return web.document.fullscreen;
  }

  @override
  bool historyPushState(String url) {
    web.window.history.pushState(null, '', url);

    return true;
  }

  @override
  String locationOrigin() {
    return web.window.location.origin;
  }
}
