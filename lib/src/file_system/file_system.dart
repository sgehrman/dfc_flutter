import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/file_system/server_files.dart';
import 'package:dfc_flutter/src/file_system/zip_archive.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileSystem {
  static final Map<String, String> _pathCache = {};

  // set to true during statup. We could use different starting paths if not granted
  static bool storagePermissionGranted = false;

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

  static Future<String?> get documentsPath async {
    String? result;

    if (Utils.isIOS) {
      // on Android this give us a data directory for some odd reason
      final Directory dir = await getApplicationDocumentsDirectory();

      result = dir.path;
    } else if (Utils.isAndroid) {
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        result = dir.path;
      }
    } else {
      // linux, windows, macOs

      final Directory dir = await getApplicationDocumentsDirectory();
      result = dir.path;
    }

    return result;
  }

  // need storage permission to view directory
  static Future<String?> get globalDocumentsPath async {
    String? result;

    if (Utils.isIOS) {
      // on Android this give us a data directory for some odd reason
      final Directory dir = await getApplicationDocumentsDirectory();

      result = dir.path;
    } else if (Utils.isAndroid) {
      final Directory? dir = await getExternalStorageDirectory();

      if (dir != null) {
        result = dir.path;

        String docsPath = _removeAndroidJunk(dir.path);

        // get the real documents directory
        // if differnet, we know we are in the right place
        if (docsPath != result) {
          docsPath = p.join(docsPath, 'Documents');
          if (Directory(docsPath).existsSync()) {
            result = docsPath;
          }
        }
      }
    } else {
      // linux, windows, macOs
      result = await documentsPath;
    }

    return result;
  }

  // used for iOS sharing
  static Future<String> get filePickerPath async {
    if (Utils.isAndroid) {
      final String path = await FileSystem.dataDirectoryPath;
      return '$path/cache/file_picker/';
    }

    // iOS
    final String? path = await FileSystem.documentsPath;

    if (path != null) {
      List<String> items = path.split('/');
      items = items.sublist(0, items.length - 1);

      return items.join('/');
    }

    return '/';
  }

  static Future<String> get dataDirectoryPath async {
    String result;

    if (Utils.isIOS) {
      final Directory directory = await getLibraryDirectory();
      result = directory.path;
    } else if (Utils.isAndroid) {
      // on Android this give us a data directory
      final Directory directory = await getApplicationDocumentsDirectory();
      result = directory.path;

      // appends app_flutter for some reason, remove that
      final ServerFile serverFile = ServerFiles.serverFileForPath(result)!;
      if (serverFile.name == 'app_flutter') {
        result = serverFile.directoryPath;
      }
    } else {
      // linux, windows, macOs
      final Directory directory = await getApplicationSupportDirectory();
      result = directory.path;
    }

    return result;
  }

  static Future<String?> get tmpDirectoryPath async {
    if (Utils.isNotEmpty(_pathCache['tmp'])) {
      return _pathCache['tmp'];
    }

    final Directory directory = await getTemporaryDirectory();
    _pathCache['tmp'] = directory.path;

    return _pathCache['tmp'];
  }

  static Future<String> get appSupportDirectoryPath async {
    final Directory directory = await getApplicationSupportDirectory();

    return directory.path;
  }

  // iOS only
  static Future<String?> get libraryDirectoryPath async {
    if (Utils.isIOS) {
      final Directory directory = await getLibraryDirectory();

      return directory.path;
    }

    return null;
  }

  // Android only
  static Future<List<String>> get externalCacheDirectoryPaths async {
    if (Utils.isAndroid) {
      final List<Directory>? directories = await getExternalCacheDirectories();

      if (directories != null) {
        return directories.map((dir) => dir.path).toList();
      }
    }

    return [];
  }

  static String _removeAndroidJunk(String path) {
    // don't want to display directories that they don't have permission to access
    if (FileSystem.storagePermissionGranted) {
      if (path.contains('Android')) {
        // remove trailing slash Directory.path and File.path return / at end
        return path.split('Android')[0].removeTrailing('/');
      }
    }

    return path;
  }

  static Future<List<String>> get externalStorageDirectoryPaths async {
    if (Utils.isAndroid) {
      // Android only call
      final List<Directory>? directories =
          await getExternalStorageDirectories();

      // add data directory
      // directories.add(Directory(await dataDirectoryPath));

      // convert to paths
      final List<String> paths = directories!.map((dir) => dir.path).toList();

      // remove android junk, remove dups with toSet()
      return paths
          .map((path) {
            return _removeAndroidJunk(path);
          })
          .toSet()
          .toList();
    }

    // iOS, not sure
    final docs = await documentsPath;

    return <String>[docs!];
  }

  // Desktop only
  static Future<String?> get downloadsDirectoryPath async {
    if (!Utils.isMobile) {
      final Directory? directory = await getDownloadsDirectory();

      if (directory != null) {
        return directory.path;
      }
    }

    return null;
  }

  static Future<File> fileInDocuments(String fileName) async {
    final documents = await documentsPath;
    return File('$documents/$fileName');
  }

  static Future<Directory> recordingDirectory() async {
    final documents = await documentsPath;
    return Directory('$documents/recordings');
  }

  static Future<Directory> booksDirectory() async {
    final documents = await documentsPath;
    final Directory dir = Directory('$documents/books');

    if (!dir.existsSync()) {
      dir.createSync();
    }

    return dir;
  }

  // iOS won't work with full paths
  // we only save the file name, and get the path fresh each time.
  static Future<String> bookPath(String filename) async {
    final Directory dir = await FileSystem.booksDirectory();
    final String path = '${dir.path}/$filename';

    return path;
  }

  static Future<List<String>> recordingPaths() async {
    final Directory dir = await recordingDirectory();

    if (!dir.existsSync()) {
      dir.createSync();
    }

    return dir.listSync().map((f) {
      return f.path;
    }).toList();
  }

  static Future<String> readFile(String fileName) async {
    try {
      final file = await fileInDocuments(fileName);

      // Read the file
      if (file.existsSync()) {
        return file.readAsString();
      }
    } catch (e) {
      // If encountering an error, return 0
      debugPrint('$e');
    }

    return '';
  }

  static Future<File> writeFile(String fileName, String contents) async {
    final file = await fileInDocuments(fileName);

    // Write the file
    return file.writeAsString(contents, flush: true);
  }

  static void delete(ServerFile serverFile) {
    if (serverFile.isDirectory!) {
      final Directory dir = Directory(serverFile.path!);

      dir.deleteSync(recursive: true);
    } else {
      final File file = File(serverFile.path!);

      file.deleteSync();
    }
  }

  static void rename(String path, String name) {
    final serverFile = ServerFiles.serverFileForPath(path)!;

    if (serverFile.isDirectory!) {
      final Directory dir = Directory(path);

      dir.renameSync(p.join(p.dirname(dir.path), name));
    } else {
      final File file = File(path);

      file.renameSync(p.join(p.dirname(file.path), name));
    }
  }

  static Future<String> compress(
    ServerFile serverFile, {
    String destinationDir = '',
  }) async {
    return ZipArchive.compress(serverFile, destinationDir);
  }

  static Future<void> decompress(ServerFile serverFile) async {
    await ZipArchive.decompress(serverFile);
  }

  static FileStat stat(String path) {
    final serverFile = ServerFiles.serverFileForPath(path)!;
    FileStat stat;

    if (serverFile.isDirectory!) {
      final Directory dir = Directory(serverFile.path!);
      stat = dir.statSync();
    } else {
      final File dir = File(serverFile.path!);
      stat = dir.statSync();
    }

    return stat;
  }

  static String? getMime(String path) {
    return mime(path);
  }

  static Future<List<ServerFile>> getStorageList() async {
    final List<String> dirs = await externalStorageDirectoryPaths;
    final List<ServerFile> result = <ServerFile>[];

    for (final String path in dirs) {
      final ServerFile? file = ServerFiles.serverFileForPath(path);

      if (file != null) {
        result.add(file);
      }
    }

    return result;
  }
}
