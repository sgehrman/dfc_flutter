import 'dart:async';

import 'package:dfc_flutter/src/dialogs/confirm_dialog.dart';
import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/hive_db/hive_box.dart';
import 'package:dfc_flutter/src/utils/browser_prefs.dart';
import 'package:dfc_flutter/src/utils/stack.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// web and mobile have different implementations, see DropStackImpMobile, DropStackImpWeb
typedef DropStackImplementation = void Function(
  BuildContext context,
  ServerFile serverFile,
  ServerFile directory,
);

class DropStack extends ChangeNotifier {
  factory DropStack() {
    return _instance ??= DropStack._();
  }
  DropStack._();

  static DropStack? _instance;
  final ListStack<ServerFile> _stack = ListStack<ServerFile>();
  static DropStackImplementation? imp;

  int get count => _stack.length;
  bool get isEmpty => _stack.isEmpty;
  bool get isNotEmpty => _stack.isNotEmpty;

  void clear() {
    _stack.clear();

    notifyListeners();
  }

  bool _inStack(ServerFile serverFile) {
    final list = _stack.list;
    final String? test = serverFile.path;

    for (final item in list) {
      if (item.path == test) {
        return true;
      }
    }

    return false;
  }

  Future<void> add(ServerFile serverFile) async {
    // don't add duplicates
    if (!_inStack(serverFile)) {
      _stack.push(serverFile);

      notifyListeners();
    }
  }

  // _dropFile isn't async because we don't want to wait until completed
  void _dropFile(
    BuildContext context,
    ServerFile serverFile,
    ServerFile directory,
  ) {
    if (DropStack.imp != null) {
      DropStack.imp!(context, serverFile, directory);
    } else {
      print('Set the imp on DropStack');
    }
  }

  Future<bool?> _confirmDrop({
    required BuildContext context,
    required ServerFile directory,
    required bool topOnly,
  }) async {
    final List<Widget> itemsDropping = [];

    for (final serverFile in _stack.list) {
      itemsDropping.add(
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(
            serverFile.name.preTruncate(),
          ),
        ),
      );

      if (topOnly) {
        break;
      }
    }

    return showConfirmDialog(
      context: context,
      title: 'Confirm Drop',
      okButtonName: 'Drop',
      children: <Widget>[
        Text(
          'Dropping:',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 6),
        ...itemsDropping,
        const SizedBox(height: 10),
        Text('To:', style: TextStyle(color: Theme.of(context).primaryColor)),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text(directory.name.preTruncate()),
        ),
        ValueListenableBuilder<Box>(
          valueListenable: HiveBox.prefsBox.listenable()!,
          builder: (BuildContext context, Box<dynamic> prefsBox, Widget? _) {
            final color = Theme.of(context).primaryColor;

            return Column(
              children: [
                SwitchListTile(
                  value: BrowserPrefs.copyOnDrop!,
                  activeColor: color,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: color,
                  selected: true,
                  onChanged: (bool newValue) {
                    BrowserPrefs.copyOnDrop = newValue;
                  },
                  title: Text(
                    BrowserPrefs.copyOnDrop!
                        ? 'Perform a Copy'
                        : 'Perform a Move',
                  ),
                ),
                SwitchListTile(
                  value: BrowserPrefs.replaceOnDrop!,
                  activeColor: color,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor: color,
                  selected: true,
                  onChanged: (bool newValue) {
                    BrowserPrefs.replaceOnDrop = newValue;
                  },
                  title: const Text('Replace'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> drop({
    required BuildContext context,
    required ServerFile directory,
    required bool topOnly,
  }) async {
    if (isNotEmpty) {
      if (directory.isDirectory!) {
        final bool? drop = await _confirmDrop(
          context: context,
          directory: directory,
          topOnly: topOnly,
        );

        if (drop == true) {
          bool done = false;

          while (!done) {
            final ServerFile? serverFile = _stack.pop();

            if (serverFile != null) {
              _dropFile(context, serverFile, directory);
            } else {
              done = true;
            }

            if (topOnly) {
              done = true;
            }
          }

          notifyListeners();
        }
      }
    }
  }
}
