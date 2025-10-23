import 'dart:js_interop';

import 'package:dfc_flutter/src/web_utils/web_utils_interface.dart';
import 'package:web/web.dart' as web;
import 'package:web_browser_detect/web_browser_detect.dart';

class WebUtilsImp implements WebUtilsInterface {
  @override
  bool isChrome() {
    final browser = Browser();

    return browser.browserAgent == BrowserAgent.chrome;
  }

  @override
  bool isSafari() {
    final browser = Browser();

    return browser.browserAgent == BrowserAgent.safari;
  }

  @override
  bool isFireFox() {
    final browser = Browser();

    return browser.browserAgent == BrowserAgent.firefox;
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

  @override
  void injectSeo(String html) {
    final body = web.document.body;
    if (body == null) {
      return;
    }

    body.insertAdjacentHTML(
      'afterBegin',
      '<div static-seo style="position: fixed; width: 1px; height: 1px; overflow: hidden;">$html</div>'
          .toJS,
    );
  }
}
