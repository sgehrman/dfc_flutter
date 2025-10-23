import 'package:dfc_flutter/src/web_utils/web_utils_interface.dart';

class WebUtilsImp implements WebUtilsInterface {
  @override
  bool isChrome() {
    return false;
  }

  @override
  bool isSafari() {
    return false;
  }

  @override
  bool isFireFox() {
    return false;
  }

  @override
  bool isFullscreen() {
    return false;
  }

  @override
  bool historyPushState(String url) {
    return false;
  }

  @override
  String locationOrigin() {
    return '';
  }

  @override
  void injectSeo(String html) {}
}
