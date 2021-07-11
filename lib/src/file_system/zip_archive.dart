import 'dart:io';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:path/path.dart' as p;

import 'package:flutter_archive/flutter_archive.dart';

class ZipArchive {
  static Future<String> compress(
    ServerFile serverFile,
    String destinationDir,
  ) async {
    String destDir = destinationDir;
    if (Utils.isEmpty(destDir)) {
      destDir = serverFile.directoryPath;
    }

    final String outputName = _uniqueCompressZipName(serverFile.name, destDir);

    final zipFile = File(outputName);

    if (serverFile.isDirectory!) {
      final dataDir = Directory(serverFile.path!);
      try {
        await ZipFile.createFromDirectory(
          sourceDir: dataDir,
          zipFile: zipFile,
          includeBaseDirectory: true,
        );
      } catch (e) {
        print(e);
      }
    } else {
      try {
        await ZipFile.createFromFiles(
          sourceDir: Directory(serverFile.directoryPath),
          files: [File(serverFile.path!)],
          zipFile: zipFile,
        );
      } catch (e) {
        print(e);
      }
    }

    return outputName;
  }

  static Future<void> decompress(ServerFile serverFile) async {
    final zipFile = File(serverFile.path!);
    final destinationDir = Directory(serverFile.directoryPath);

    // decompress into a tmp folder, then move the contents out renaming if needed to avoid conflicts
    final String tmpDirPath =
        Utils.uniqueDirName('.zipTmp', destinationDir.path);

    final tmpDir = Directory(tmpDirPath);
    tmpDir.createSync();

    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: tmpDir);

      for (final entity in tmpDir.listSync()) {
        final bool isDirectory = entity is Directory;

        if (isDirectory) {
          final Directory dir = entity;

          final String newPath =
              Utils.uniqueDirName(p.basename(dir.path), destinationDir.path);

          dir.renameSync(newPath);
        } else {
          final File file = entity as File;

          final String newPath =
              Utils.uniqueFileName(p.basename(file.path), destinationDir.path);

          file.renameSync(newPath);
        }
      }

      // shouldn't need recursive since all items should have been moved out
      tmpDir.deleteSync();
    } catch (e) {
      print(e);
    }
  }

  static String _uniqueCompressZipName(String name, String destinationDir) {
    String outputName = '$destinationDir/$name.zip';

    int nameIndex = 1;
    while (
        File(outputName).existsSync() || Directory(outputName).existsSync()) {
      final String baseName = p.basenameWithoutExtension(name);
      final String extension = p.extension(name);

      outputName = '$destinationDir/$baseName-$nameIndex$extension.zip';
      nameIndex++;
    }

    return outputName;
  }
}
