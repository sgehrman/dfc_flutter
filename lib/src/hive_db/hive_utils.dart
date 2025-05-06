import 'package:dfc_flutter/src/hive_db/hive_box.dart';
import 'package:dfc_flutter/src/hive_db/hive_data.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HiveUtils {
  HiveUtils._();

  static Future<void> init({String prefsBoxName = 'prefs'}) async {
    WidgetsFlutterBinding.ensureInitialized();

    // store this in the application support on iOS
    // await Hive.initFlutter('hive'); doesn't allow picking location
    if (!Utils.isWeb) {
      if (Utils.isMobile) {
        // data directory on android
        var appDir = await getApplicationDocumentsDirectory();

        if (Utils.isIOS) {
          appDir = await getLibraryDirectory();
        }

        var path = appDir.path;
        path = p.join(path, 'app_data');
        Hive.init(path);
      } else if (Utils.isDesktop) {
        // flatpak:
        // /home/steve/.var/app/com.cocoatech.Driftwood/data/driftwood
        // normal:
        // /home/steve/.local/share/re.distantfutu.dashboard
        final appDir = await getApplicationSupportDirectory();

        var path = appDir.path;
        path = p.join(path, 'app_data');
        Hive.init(path);
      } else {
        // a server
        Hive.init('./hive');
      }
    }

    // register adapters
    Hive.registerAdapter<HiveData>(HiveDataAdapter());

    // open prefs box before app runs so it's ready
    await PrefsBox().init(prefsBoxName);
  }
}

// =============================================================

// name is normally 'prefs', but in Deckr it was creating two prefs boxes
// one for the extension and another for the loaded browser app
// I once saw my prefs get wiped and someone else said there was an issue with prefs saving
// to be safe the extension uses a different name
// never confirmed that this is a real issue, but it does seem problematic so this fixes it

class PrefsBox {
  factory PrefsBox() {
    return _instance ??= PrefsBox._();
  }

  PrefsBox._();

  static PrefsBox? _instance;
  late final HiveBox<dynamic> _prefs;

  HiveBox<dynamic> get box => _prefs;

  Future<void> init(String name) async {
    _prefs = HiveBox<dynamic>.box(name);

    await _prefs.open();
  }
}

// =============================================================

// return ValueListenableBuilder(
//   valueListenable: widget.hiveBox.listenable(),
//   builder: (BuildContext context, Box<ScanData> __, Widget _) {
//       return xx;
//   },
// ),

// not sure where I got this
// ValueListenableProvider.value(
//       value : widget.hiveBox.listenable(),
//       child:
