import 'dart:io';

import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;

enum ServerFileType {
  unknown,
  image,
  json,
  text,
  pdf,
  archive,
  video,
  audio,
}

class ServerFile {
  ServerFile({
    required String path,
    required this.isDirectory,
    this.directoryCount,
  }) {
    // remove trailing slash Directory.path and File.path return / at end
    this.path = path.removeTrailing('/');
  }

  factory ServerFile.fromMap(Map<String, dynamic> map) {
    final result = ServerFile(
      path: map['path'] as String,
      isDirectory: map['isDirectory'] as bool?,
      directoryCount: map['directoryCount'] as int?,
    );

    result._length = map['length'] as int?;

    final mod = map['lastModified'] as String?;
    if (mod != null) {
      result._lastModified = DateTime.tryParse(mod);
    }

    return result;
  }

  String? path;
  final bool? isDirectory;
  final int? directoryCount;
  String? _name;
  String? _directoryPath;
  String? _directoryName;
  String? _extension;
  String? _lowerCaseName;
  ServerFileType? _type;
  bool? _hidden;
  DateTime? _lastAccessed;
  DateTime? _lastModified;
  int? _length;
  String? _modeString;

  bool get isFile => !isDirectory!;
  bool get isImage => type == ServerFileType.image;
  bool get isAudio => type == ServerFileType.audio;
  bool get isVideo => type == ServerFileType.video;
  bool get isPdf => type == ServerFileType.pdf;
  bool get isText => type == ServerFileType.text;
  bool get isPng => extension == '.png';
  bool get isSvg => extension == '.svg';
  bool get isArchive => type == ServerFileType.archive;
  String get name => _name ??= p.basename(path!);
  String get lowerCaseName => _lowerCaseName ??= name.toLowerCase();
  bool get hidden => _hidden ??= name.startsWith('.');
  String get directoryPath => _directoryPath ??= p.dirname(path!);
  String get directoryName => _directoryName ??= p.basename(directoryPath);

  // String get extension => _extension ??= p.extension(path).toLowerCase();
  // Wondering if this is faster than above
  String? get extension {
    if (_extension == null) {
      final lastDot = name.lastIndexOf('.', name.length - 1);
      if (lastDot != -1) {
        _extension = name.substring(lastDot).toLowerCase();
      }

      _extension ??= '';
    }

    return _extension;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'path': path,
      'isDirectory': isDirectory,
      'directoryCount': directoryCount,
      'lastModified': _lastModified?.toString(),
      'length': _length,
    };
  }

  // mobile/desktop only
  DateTime? get lastAccessed {
    if (_lastAccessed != null) {
      return _lastAccessed;
    }

    _lastAccessed = DateTime.now();

    // uses dart:io, not for web
    if (!Utils.isWeb) {
      if (isFile) {
        _lastAccessed = File(path!).lastAccessedSync();
      }
    }

    return _lastAccessed;
  }

  // this is used when detecting modified directories
  // we need a fresh mod date, call this before lastModified
  void clearLastModified() {
    _lastModified = null;
  }

  String? get modeString {
    if (_modeString != null) {
      return _modeString;
    }

    String modeStr;

    if (isFile) {
      modeStr = File(path!).statSync().modeString();
    } else if (isDirectory!) {
      modeStr = Directory(path!).statSync().modeString();
    } else {
      modeStr = 'wtfwtfwtf';
    }

    // Removes potential prepended permission bits, such as '(suid)' and '(guid)'.
    // ignore: join_return_with_assignment
    _modeString = modeStr.substring(modeStr.length - 9);

    return _modeString;
  }

  // mobile/desktop only
  DateTime? get lastModified {
    if (_lastModified != null) {
      return _lastModified;
    }

    // set to some a date in the past just to signal it's clearly not workin
    // but setting _lastModified prevents futher calls
    _lastModified = DateTime.utc(1969);

    try {
      // uses dart:io, not for web
      if (!Utils.isWeb) {
        if (isFile) {
          _lastModified = File(path!).lastModifiedSync();
        } else {
          _lastModified = Directory(path!).statSync().modified;
        }
      }
    } catch (err) {
      print('server_file.lastModified: $err');
    }

    return _lastModified;
  }

  // mobile/desktop only
  int? get length {
    if (_length != null) {
      return _length;
    }

    _length = 0;

    try {
      if (isFile) {
        // uses dart:io, not for web
        if (!Utils.isWeb) {
          _length = File(path!).lengthSync();
        }
      }
    } catch (err) {
      print('server_file.length: $err');
    }

    return _length;
  }

  // some images crash when drawing on android
  // to be safe, only draw known formats
  bool get isImageDrawable {
    if (isImage) {
      switch (extension) {
        case '.jpg':
        case '.jpeg':
        case '.png':
        case '.gif':
        case '.raw':
        case '.tiff':
        case '.bmp':
        case '.webp':
        case '.ico':
          return true;
      }
    }

    return false;
  }

  ServerFileType? get type {
    if (_type == null) {
      if (Utils.isNotEmpty(extension)) {
        var noDot = extension!;

        if (noDot.length > 1) {
          noDot = extension!.substring(1);
        }

        final mimeType = mimeFromExtension(noDot);

        if (mimeType != null) {
          switch (mimeType.split('/').first) {
            case 'image':
              // might want to set the type as an image, but filter when being drawn
              // psd for example crashes
              if (extension != '.psd') {
                _type = ServerFileType.image;
              }
              break;
            case 'text':
              _type = ServerFileType.text;
              break;
            case 'audio':
              _type = ServerFileType.audio;
              break;
            case 'video':
              // .3gp crashes, .wmv doesn't work
              if (extension != '.3gp' && extension != '.wmv') {
                _type = ServerFileType.video;
              }
              break;
          }
        }

        if (_type == null) {
          switch (extension) {
            case '.raw':
              _type = ServerFileType.image;
              break;
            case '.xml':
              _type = ServerFileType.text;
              break;
            case '.pdf':
              _type = ServerFileType.pdf;
              break;
            case '.json':
              _type = ServerFileType.json;
              break;
            case '.zip':
            case '.tar':
            case '.gz':
              _type = ServerFileType.archive;
              break;
          }
        }
      }

      _type ??= ServerFileType.unknown;
    }

    return _type;
  }

  bool get isReadOnly {
    var result = true;
    final mode = modeString;

    if (mode != null) {
      if (mode.length == 9) {
        if (mode.substring(mode.length - 2, mode.length - 1) == 'w') {
          // user
          result = false;
        } else if (mode.substring(mode.length - 5, mode.length - 4) == 'w') {
          // group
          result = false;
        } else if (mode.substring(mode.length - 8, mode.length - 7) == 'w') {
          // root

          // ios seems weird, still investigating
          // only checking root on iOS
          if (Utils.isIOS) {
            result = false;
          }
        }
      } else {
        print('modeString not 9?');
      }
    }

    return result;
  }

  Widget icon({double? size}) {
    String iconData;

    Color color = Colors.cyan;

    if (isDirectory!) {
      iconData = FontAwesomeSvgs.regularFolder;
      color = Colors.blue;
    } else if (isArchive) {
      iconData = FontAwesomeSvgs.regularFileArchive;
    } else if (isPdf) {
      iconData = FontAwesomeSvgs.regularFilePdf;
      color = Colors.deepOrange;
    } else if (isImage) {
      iconData = FontAwesomeSvgs.regularImage;
      color = Colors.green;
    } else if (type == ServerFileType.text) {
      iconData = FontAwesomeSvgs.regularFileCode;
      color = Colors.pink;
    } else if (type == ServerFileType.video) {
      iconData = FontAwesomeSvgs.regularFileVideo;
      color = Colors.brown;
    } else if (type == ServerFileType.audio) {
      iconData = FontAwesomeSvgs.regularFileAudio;
      color = Colors.brown;
    } else {
      iconData = FontAwesomeSvgs.regularFile;
    }

    return SvgIcon(iconData, size: size, color: color);
  }

  @override
  String toString() {
    return path!;
  }

  @override
  bool operator ==(Object other) {
    if (other is ServerFile) {
      if (other.path == path && other.isDirectory == isDirectory) {
        return true;
      }
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(
        path,
        isDirectory,
      );
}
