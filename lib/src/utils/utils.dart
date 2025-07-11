import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:dfc_flutter/l10n/app_localizations.dart';
import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/widgets/shared_context.dart';
import 'package:dfc_flutter/src/widgets/shared_snack_bar.dart';
import 'package:dfc_flutter/src/widgets/ttext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart' as launcher;

// Some globals I may want to experiment with

class Utils {
  static final math.Random _random = math.Random();

  static bool get debugBuild {
    return kDebugMode || kProfileMode;
  }

  static String uniqueFirestoreId() {
    const idLength = 20;
    const alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final stringBuffer = StringBuffer();
    const maxRandom = alphabet.length;

    for (var i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }

  static String modifyTextForWrapping(String? text) {
    // cool hack so that the ellipsis doesn't break on words 'test this' => 'test...' with: 'test thi...'
    // this can make multiline breaks break between words which looks bad
    // You can prevent a line break after a slash by inserting a zero-width non-breaking character,
    // such as the WORD JOINER (U+2060), immediately after the slash. For example, typing "/\u2060" (slash followed by word joiner)
    // in your text will keep the content before and after the slash together on the same line
    return (text ?? 'null')
        .replaceAll(' ', '\u00A0')
        .replaceAll('-', '\u{2011}')
        .replaceAll('/', '/\u{2060}');
  }

  static void showLicenses(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Theme(data: ThemeData.light(), child: const LicensePage());
        },
      ),
    );
  }

  static String uniqueFileName(String name, String directoryPath) {
    var nameIndex = 1;
    final fileName = name;
    var tryDirName = fileName;

    var destFile = p.join(directoryPath, tryDirName);
    while (File(destFile).existsSync() || Directory(destFile).existsSync()) {
      // test-1.xyz
      final baseName = p.basenameWithoutExtension(fileName);
      final extension = p.extension(fileName);

      tryDirName = '$baseName-$nameIndex$extension';
      destFile = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFile;
  }

  static String uniqueDirName(String name, String directoryPath) {
    var nameIndex = 1;
    final dirName = p.basenameWithoutExtension(name);
    var tryDirName = dirName;

    var destFolder = p.join(directoryPath, tryDirName);
    while (
        File(destFolder).existsSync() || Directory(destFolder).existsSync()) {
      tryDirName = '$dirName-$nameIndex';
      destFolder = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFolder;
  }

  // ===========================================
  // Package Info

  static bool get isAndroid {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isAndroid;
  }

  static bool get isIOS {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isIOS;
  }

  static bool get isMobile {
    return isAndroid || isIOS;
  }

  static bool get isDesktop {
    return isMacOS || isLinux || isWindows;
  }

  static bool get isMacOS {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isMacOS;
  }

  static bool get isLinux {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isLinux;
  }

  static bool get isWindows {
    // Platform not available on web
    if (isWeb) {
      return false;
    }

    return Platform.isWindows;
  }

  static bool get isWeb {
    // Platform not available on web
    // but this constant is the current work around
    return kIsWeb;
  }

  // -----------------------------------------------------------

  // used for web to find out underlying host OS
  static bool onDesktop(BuildContext context) {
    return onWindows(context) ||
        onMac(context) ||
        onLinux(context) ||
        onFuchsia(context);
  }

  static bool onMobile(BuildContext context) {
    return oniOS(context) || onAndroid(context);
  }

  // used for web to find out underlying host OS
  static bool onWindows(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.windows;
  }

  // used for web to find out underlying host OS
  static bool onMac(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.macOS;
  }

  // used for web to find out underlying host OS
  static bool onLinux(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.linux;
  }

  // used for web to find out underlying host OS
  static bool oniOS(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  // used for web to find out underlying host OS
  static bool onAndroid(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.android;
  }

  // used for web to find out underlying host OS
  static bool onFuchsia(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.fuchsia;
  }

  // -----------------------------------------------------------

  static bool versionOutOfDate({
    required String oldVersion,
    required String newVersion,
  }) {
    // version can be 1.2.3.4, or 1.2.3+4
    final oldV = oldVersion.replaceAll('+', '.');
    final newV = newVersion.replaceAll('+', '.');

    final oldDigits = oldV.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final newDigits = newV.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final int cnt = math.min(oldDigits.length, newDigits.length);

    for (var i = 0; i < cnt; i++) {
      if (newDigits[i] > oldDigits[i]) {
        return true;
      }
    }

    if (newDigits.length > oldDigits.length) {
      return true;
    }

    return false;
  }

  // use this function for proper version with build number
  // ex. 1.0.2+69
  static Future<String> appVersion() async {
    final v = await getAppVersion();
    final b = await getAppBuildNumber();

    if (b.isNotEmpty) {
      return '$v+$b';
    }

    return v;
  }

  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.version;
    } catch (err) {
      print(err);
    }

    return '1.0.2';
  }

  static Future<String> getAppBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.buildNumber;
    } catch (err) {
      print(err);
    }

    return '48';
  }

  static Future<String> getAppID() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.packageName;
    } catch (err) {
      print(err);
    }

    return '0.0.7';
  }

  static String? _webAppName;
  static set webAppName(String name) => _webAppName = name;
  static Future<String> getAppName() async {
    if (isWeb) {
      return _webAppName ?? 'web';
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();

      return packageInfo.appName;
    } catch (err) {
      print(err);
    }

    return 'unknown';
  }

  static void showBanner(
    BuildContext context,
    String message, {
    bool error = false,
    String buttonName = 'Dismiss',
  }) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: Text(message),
        leading: const Icon(Icons.info),
        backgroundColor: error ? Colors.red[700] : Colors.green[800],
        actions: [
          TextButton(
            child: Text(buttonName),
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
          ),
        ],
      ),
    );
  }

  static void showSnackbar(
    BuildContext context,
    String message, {
    bool error = false,
    String? action,
    void Function()? onPressed,
  }) {
    final snackBar = SnackBar(
      backgroundColor: error ? Colors.red[700] : Colors.green[800],
      content: TText(message, style: const TextStyle(color: Colors.white)),
      action: action != null
          ? SnackBarAction(label: action, onPressed: onPressed!)
          : null,
    );

    // remove any existing snackbars first otherwise they can queue up and take forever to finish
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool isControlKeyDown() {
    final keys = HardwareKeyboard.instance.logicalKeysPressed;

    return keys.contains(
          LogicalKeyboardKey.controlLeft,
        ) ||
        keys.contains(
          LogicalKeyboardKey.controlRight,
        );
  }

  static void copyToClipboard(String text) {
    final l10n = AppLocalizations.of(SharedContext().scaffoldContext);

    Clipboard.setData(ClipboardData(text: text));

    final message = text.truncate(60).replaceAll('\n', ' ');

    Utils.successSnackbar(title: l10n.copied, message: message);
  }

  static Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final data = await rootBundle.load(imageAssetPath);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  static Future<ui.Image> loadImageFromPath(String imagePath) {
    final file = File(imagePath);

    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(file.readAsBytesSync(), (img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  // ===========================================
  // Misc

  static Size mediaSquareSize(
    BuildContext context, {
    double percent = 0.5,
    double? maxDimension,
  }) {
    double dimension = math.min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    dimension = dimension * percent;
    if (maxDimension != null) {
      dimension = math.min(maxDimension, dimension);
    }

    return Size(dimension, dimension);
  }

  // set newTab to false for downloads
  //  webOnlyWindowName: '_self', // no flicker on click
  static Future<void> launchUrl(String url, {bool newTab = true}) async {
    // canLaunchUrl doesn't work with flatpak on linux
    // https://github.com/flutter/flutter/issues/88463
    // could throw PlatformException on some platforms
    // if (await launcher.canLaunchUrl(Uri.parse(url))) {
    try {
      final result = await launcher.launchUrl(
        Uri.parse(url),
        webOnlyWindowName: newTab ? null : '_self',
      );

      if (!result) {
        print('Could not launch $url');
      }
    } catch (err) {
      print(err);
    }
  }

  static SystemUiOverlayStyle systemUiStyle(BuildContext context) {
    if (Utils.isDarkMode(context)) {
      return SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      );
    }

    return SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    );
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void scrollToEndAnimated(
    ScrollController scrollController, {
    bool reversed = false,
  }) {
    scrollController.animateTo(
      reversed
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  static void scrollToEnd(
    ScrollController scrollController, {
    bool reversed = false,
  }) {
    scrollController.jumpTo(
      reversed
          ? scrollController.position.minScrollExtent
          : scrollController.position.maxScrollExtent,
    );
  }

  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  // 4 -> 04,
  static String twoDigits(num n) {
    if (n >= 10 || n <= -10) {
      return '$n';
    }

    if (n < 0) {
      return '-0${n.abs()}';
    }

    return '0$n';
  }

  static bool isNotEmpty(dynamic input) {
    if (input == null) {
      return false;
    }

    if (input is String) {
      return input.isNotEmpty;
    }

    // iterable includes List
    if (input is Iterable) {
      return input.isNotEmpty;
    }

    if (input is Map) {
      return input.isNotEmpty;
    }

    print('### isNotEmpty called on ${input.runtimeType}');

    return false;
  }

  static T? enumFromString<T extends Enum>(List<T> enumValues, String name) {
    if (enumValues.isEmpty || name.isEmpty) {
      return null;
    }

    return enumValues.singleWhereOrNull((e) {
      // not sure if .toLowerCase() is necessary, but old code was doing this
      return e.name.toLowerCase() == name.toLowerCase();
    });
  }

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }

  static String htmlToMd(String text) {
    return html2md.convert(text);
  }

  static void successSnackbar({
    required String title,
    required String message,
    bool error = false,
  }) {
    SharedSnackBars().show(title: title, message: message, error: error);
  }

  // removes null value, empty strings, empty lists, empty maps
  static dynamic removeNulls(dynamic params) {
    if (params is Map) {
      final result = <dynamic, dynamic>{};

      params.forEach((dynamic key, dynamic value) {
        final dynamic val = removeNulls(value);
        if (val != null) {
          result[key] = val;
        }
      });

      if (Utils.isNotEmpty(result)) {
        return result;
      }

      return null;
    } else if (params is List) {
      final result = <dynamic>[];

      for (final val in params) {
        final dynamic v = removeNulls(val);
        if (v != null) {
          result.add(v);
        }
      }

      if (Utils.isNotEmpty(result)) {
        return result;
      }

      return null;
    } else if (params is String) {
      if (Utils.isNotEmpty(params)) {
        return params;
      }

      return null;
    }

    return params;
  }
}

class NothingWidget extends SizedBox {
  // this is just a shorthand for a SizedBox to let the coder know
  // we want a nothing placeholder widget
  const NothingWidget();
}

// if you want the contents scrollable when the keyboard comes up to avoid clipping
class ScrollWrapper extends StatelessWidget {
  const ScrollWrapper(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraint.maxHeight,
              maxWidth: constraint.maxWidth,
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    var hc = hexColor.toUpperCase().replaceAll('#', '');
    if (hc.length == 6) {
      hc = 'FF$hc';
    }

    return int.parse(hc, radix: 16);
  }
}
