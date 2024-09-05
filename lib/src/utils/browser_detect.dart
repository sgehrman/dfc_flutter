import 'package:web/web.dart' as web;

// =======================================================
// copied from https://pub.dev/packages/web_browser_detect

enum BrowserAgent {
  unKnown,
  chrome,
  safari,
  firefox,
  explorer,
  edge,
  edgeChromium,
}

class BrowserDetect {
  factory BrowserDetect() {
    return _instance ??= BrowserDetect._();
  }

  BrowserDetect._() {
    String appVersion = '';
    appVersion = web.window.navigator.appVersion;

    _detectBrowser(
      userAgent: web.window.navigator.userAgent,
      vendor: web.window.navigator.vendor,
      appVersion: appVersion,
    );
  }

  static BrowserDetect? _instance;

  bool isChrome() {
    return browserAgent == BrowserAgent.chrome;
  }

  bool isSafari() {
    return browserAgent == BrowserAgent.safari;
  }

  bool isFireFox() {
    return browserAgent == BrowserAgent.firefox;
  }

  BrowserAgent get browserAgent =>
      _detected?.browserAgent ?? BrowserAgent.unKnown;

  String get browser => _browserIdentifiers[browserAgent]!;

  String get version => _version;

  static const Map<BrowserAgent, String> _browserIdentifiers =
      <BrowserAgent, String>{
    BrowserAgent.unKnown: 'Unknown browser',
    BrowserAgent.chrome: 'Chrome',
    BrowserAgent.safari: 'Safari',
    BrowserAgent.firefox: 'Firefox',
    BrowserAgent.explorer: 'Internet Explorer',
    BrowserAgent.edge: 'Edge',
    BrowserAgent.edgeChromium: 'Chromium Edge',
  };

  _BrowserDetection? _detected;
  String _version = 'Unknown version';

  /// Detect current browser if it is known
  void _detectBrowser({
    required String userAgent,
    required String vendor,
    required String appVersion,
  }) {
    final List<_BrowserDetection> detections = <_BrowserDetection>[
      _BrowserDetection(
        browserAgent: BrowserAgent.edgeChromium,
        string: userAgent,
        subString: 'Edg',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.chrome,
        string: userAgent,
        subString: 'Chrome',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.safari,
        string: vendor,
        subString: 'Apple',
        versionSearch: 'Version',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.firefox,
        string: userAgent,
        subString: 'Firefox',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'MSIE',
        versionSearch: 'MSIE',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.explorer,
        string: userAgent,
        subString: 'Trident',
        versionSearch: 'rv',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.edge,
        string: userAgent,
        subString: 'Edge',
      ),
    ];

    for (final _BrowserDetection detection in detections) {
      if (detection.string.contains(detection.subString)) {
        _detected = detection;

        final String versionSearchString =
            detection.versionSearch ?? detection.subString;
        String versionFromString = userAgent;
        int index = versionFromString.indexOf(versionSearchString);
        if (index == -1) {
          versionFromString = appVersion;
          index = versionFromString.indexOf(versionSearchString);
        }

        if (index == -1) {
          _version = 'Unknown version';
        } else {
          _version = versionFromString
              .substring(index + versionSearchString.length + 1);

          if (_version.split(' ').length > 1) {
            _version = _version.split(' ').first;
          }
        }

        break;
      }
    }
  }
}

class _BrowserDetection {
  /// BrowserDetection initialization
  _BrowserDetection({
    required this.browserAgent,
    required this.string,
    required this.subString,
    this.versionSearch,
  });
  final BrowserAgent browserAgent;
  final String string;
  final String subString;
  final String? versionSearch;
}
