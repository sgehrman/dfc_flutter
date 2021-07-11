import 'dart:async';
import 'dart:io';

import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/file_system/standard_directories.dart';

class ServerFiles {
  static ServerFile? serverFileForPath(String path, {bool verify = false}) {
    final bool isDirectory = FileSystemEntity.isDirectorySync(path);

    bool valid = true;

    if (verify) {
      if (isDirectory) {
        final Directory dir = Directory(path);
        valid = dir.existsSync();
      } else {
        final File file = File(path);
        valid = file.existsSync();
      }
    }

    if (valid) {
      return ServerFile(path: path, isDirectory: isDirectory);
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> mobileDirectories() async {
    final List<Map<String, dynamic>> result = [];

    final List<ServerFile> dirs =
        await StandardDirectories().standardDirectories();

    // NOTE
    // THIS DATA is converted to Json, don't put in anything that can't be encoded
    for (final serverFile in dirs) {
      result.add(<String, dynamic>{
        'name': StandardDirectories().displayName(serverFile),
        'path': serverFile.path,
      });
    }

    return result;
  }
}
