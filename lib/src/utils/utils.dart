import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:collection/collection.dart' show IterableExtension;
import 'package:dfc_flutter/src/widgets/shared_snack_bar.dart';
import 'package:dfc_flutter/src/widgets/ttext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

// Some globals I may want to experiment with

class Utils {
  static final Random _random = Random();

  static bool get debugBuild {
    return kDebugMode || kProfileMode;
  }

  // same as unawaited in Pedantic package
  static void dontWait(Future<void> future) {}

  static String uniqueFirestoreId() {
    const int idLength = 20;
    const String alphabet =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = alphabet.length;

    for (int i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }

  static void showLicenses(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Theme(
            data: ThemeData.light(),
            child: const LicensePage(),
          );
        },
      ),
    );
  }

  static Future<void> printAssets(
    BuildContext context, {
    String? directoryName,
    String? ext,
  }) async {
    String matchDir = '';
    String matchExt = '';

    if (directoryName != null && ext!.isNotEmpty) {
      matchDir = directoryName;
    }

    if (ext != null && ext.isNotEmpty) {
      matchExt = ext;
    }

    final bundle = DefaultAssetBundle.of(context);

    final manifestContent = await bundle.loadString('AssetManifest.json');

    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final List<String> paths = manifestMap.keys
        .where((String key) => key.contains(matchDir))
        .where((String key) => key.contains(matchExt))
        .toList();

    for (final String p in paths) {
      debugPrint('ASSET: $p', wrapWidth: 555);
    }
  }

  static String uniqueFileName(String name, String directoryPath) {
    int nameIndex = 1;
    final String fileName = name;
    String tryDirName = fileName;

    String destFile = p.join(directoryPath, tryDirName);
    while (File(destFile).existsSync() || Directory(destFile).existsSync()) {
      // test-1.xyz
      final String baseName = p.basenameWithoutExtension(fileName);
      final String extension = p.extension(fileName);

      tryDirName = '$baseName-$nameIndex$extension';
      destFile = p.join(directoryPath, tryDirName);

      nameIndex++;
    }

    return destFile;
  }

  static String uniqueDirName(String name, String directoryPath) {
    int nameIndex = 1;
    final String dirName = p.basenameWithoutExtension(name);
    String tryDirName = dirName;

    String destFolder = p.join(directoryPath, tryDirName);
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

  static Future<String> getAppVersion() async {
    if (isWeb) {
      return '1.0.2';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getAppID() async {
    if (isWeb) {
      return '0.0.7';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static String? _webAppName;
  static set webAppName(String name) => _webAppName = name;
  static Future<String> getAppName() async {
    if (isWeb) {
      return _webAppName ?? 'web';
    }

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.appName;
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
      content: TText(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      action: action != null
          ? SnackBarAction(
              label: action,
              onPressed: onPressed!,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<void> showCopiedToast(BuildContext context) async {
    await Navigator.of(context).push<void>(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => _Toast(),
      ),
    );
  }

  static Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<ui.Image> loadImageFromPath(String imagePath) async {
    final File file = File(imagePath);

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(file.readAsBytesSync(), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  // ===========================================
  // Misc

  static bool equalColors(Color? color1, Color? color2) {
    // colors don't compare well, one might be a material color, the other just has a Color(value)
    // both both might have the same value and should be considered equal
    return color1?.value == color2?.value;
  }

  static Size mediaSquareSize(
    BuildContext context, {
    double percent = 0.5,
    double? maxDimension,
  }) {
    double dimension = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    );

    dimension = dimension * percent;
    if (maxDimension != null) {
      dimension = min(maxDimension, dimension);
    }

    return Size(dimension, dimension);
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  static Future<void> launchUrl(String url, {bool newTab = true}) async {
    if (await canLaunch(url)) {
      // the default is newTab, '_blank', set _self for same window on web
      await launch(url, webOnlyWindowName: newTab ? null : '_self');
    } else {
      print('Could not launch $url');
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

  static List<MatchText> matchArray({
    bool email = true,
    bool phone = true,
    bool url = true,
  }) {
    final result = <MatchText>[];

    if (email) {
      result.add(
        MatchText(
          type: ParsedType.EMAIL,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 24,
          ),
          onTap: (String r) => Utils.matchCallback('email', r),
        ),
      );
    }

    if (phone) {
      result.add(
        MatchText(
          type: ParsedType.PHONE,
          style: const TextStyle(
            color: Colors.blue,
          ),
          onTap: (String r) => Utils.matchCallback('phone', r),
        ),
      );
    }

    if (url) {
      result.add(
        MatchText(
          type: ParsedType.URL,
          style: const TextStyle(
            color: Colors.blue,
          ),
          onTap: (String r) => Utils.matchCallback('url', r),
        ),
      );
    }

    return result;
  }

  static void matchCallback(String type, String payload) {
    switch (type) {
      case 'email':
        Utils.launchUrl('mailto:$payload');
        break;
      case 'phone':
        Utils.launchUrl('tel:$payload');
        break;
      case 'url':
        Utils.launchUrl(payload);
        break;
    }
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

  static bool isEmpty(dynamic input) {
    return !isNotEmpty(input);
  }

  static void successSnackbar({
    required String title,
    required String message,
    bool error = false,
  }) {
    SharedSnackBars().show(
      title: title,
      message: message,
      error: error,
    );
  }

  static String enumToString(Object? enumItem) {
    if (enumItem == null) {
      return '';
    }

    return describeEnum(enumItem);
  }

  static T? enumFromString<T>(
    List<T> enumValues,
    String value,
  ) {
    if (Utils.isEmpty(enumValues) || Utils.isEmpty(value)) {
      return null;
    }

    return enumValues.singleWhereOrNull(
      (enumItem) => enumToString(enumItem).toLowerCase() == value.toLowerCase(),
    );
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

  static Future<String?> jsonAssets({
    required BuildContext context,
    required String directoryName,
    required String filename,
  }) async {
    final bundle = DefaultAssetBundle.of(context);

    final manifestContent = await bundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap =
        json.decode(manifestContent) as Map<String, dynamic>;

    final List<String> paths = manifestMap.keys.where((String path) {
      final dirPath = p.split(p.dirname(path));

      if (Utils.isNotEmpty(dirPath)) {
        return directoryName == dirPath.last;
      }

      return false;
    }).where((String path) {
      return p.basename(path) == filename;
    }).toList();

    if (paths.length == 1) {
      final contents = await bundle.loadString(paths[0]);

      // debugPrint(contents, wrapWidth: 555);

      return contents;
    }

    print('jsonAssets: not found');

    return null;
  }
}

class NothingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // could also try this
    // return SizedBox(width: 0, height: 0);

    // error message says this takes up as little space as possible
    return const SizedBox(width: 0, height: 0);
  }
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
    String hc = hexColor.toUpperCase().replaceAll('#', '');
    if (hc.length == 6) {
      hc = 'FF$hc';
    }
    return int.parse(hc, radix: 16);
  }
}

class _Toast extends StatefulWidget {
  @override
  __ToastState createState() => __ToastState();
}

class __ToastState extends State<_Toast> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: const Text(
              'Copied',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
