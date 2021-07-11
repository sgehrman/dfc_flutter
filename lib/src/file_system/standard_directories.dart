import 'dart:io';

import 'package:dfc_flutter/src/file_system/file_system.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/file_system/server_files.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

class StandardDirectories {
  factory StandardDirectories() {
    return _instance ??= StandardDirectories._();
  }
  StandardDirectories._();
  static StandardDirectories? _instance;

  final Map<String?, String> _displayNameMap = {};
  List<ServerFile?>? _standardDirectories;

  Future<List<ServerFile>> standardDirectories() async {
    if (_standardDirectories == null) {
      final List<String?> result = [];
      String? path;
      final String documentsPath = await FileSystem.globalDocumentsPath;

      // iOS uses the file_picker directory as it's home
      if (Utils.isIOS) {
        // if (Utils.isAndroid) {
        final String filePickerPath = await FileSystem.filePickerPath;

        result.add(filePickerPath);
        _displayNameMap[filePickerPath] = 'Shared';
      }

      result.add(documentsPath);
      _displayNameMap[documentsPath] = 'Documents';

      path = await FileSystem.dataDirectoryPath;
      result.add(path);
      _displayNameMap[path] = 'Data';

      path = await FileSystem.tmpDirectoryPath;
      result.add(path);
      _displayNameMap[path] = 'Temporary';

      if (Utils.isIOS) {
        path = await FileSystem.appSupportDirectoryPath;
        result.add(path);
        _displayNameMap[path] = 'App Support';

        path = await FileSystem.libraryDirectoryPath;
        result.add(path);
        _displayNameMap[path] = 'Library';
      }

      if (Utils.isAndroid) {
        path = '/storage/emulated/0/Pictures/Screenshots';
        if (Directory(path).existsSync()) {
          result.add(path);
          _displayNameMap[path] = 'Screenshots';
        }

        for (final p in await FileSystem.externalCacheDirectoryPaths) {
          // returns documents when there is nothing
          if (p != documentsPath) {
            result.add(p);

            _displayNameMap[p] = 'External Cache';
          }
        }

        for (final p in await FileSystem.externalStorageDirectoryPaths) {
          // returns documents when there is nothing
          if (p != documentsPath) {
            result.add(p);
            _displayNameMap[p] = 'External Storage';
          }
        }
      }

      _standardDirectories = result.map((p) {
        return ServerFiles.serverFileForPath(p!);
      }).toList();
    }

    // return a copy
    return List<ServerFile>.from(_standardDirectories!);
  }

  String? displayName(ServerFile serverFile) {
    String? result = _displayNameMap[serverFile.path];

    if (Utils.isEmpty(result)) {
      result = serverFile.name;
    }

    return result;
  }
}
