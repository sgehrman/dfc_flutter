import 'package:dfc_flutter/src/file_system/directory_listing_spec.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/hive_db/hive_box.dart';

class BrowserPrefs {
  static bool? get showHidden =>
      HiveBox.prefsBox.get('showHidden', defaultValue: false) as bool?;
  static set showHidden(bool? flag) => HiveBox.prefsBox.put('showHidden', flag);

  static String? get sortType =>
      HiveBox.prefsBox.get('sortType', defaultValue: SortTypes.sortByName)
          as String?;
  static set sortType(String? style) => HiveBox.prefsBox.put('sortType', style);

  static bool? get sortAscending =>
      HiveBox.prefsBox.get('sortAscending', defaultValue: true) as bool?;
  static set sortAscending(bool? style) =>
      HiveBox.prefsBox.put('sortAscending', style);

  static bool? get sortFoldersFirst =>
      HiveBox.prefsBox.get('sortFoldersFirst', defaultValue: true) as bool?;
  static set sortFoldersFirst(bool? style) =>
      HiveBox.prefsBox.put('sortFoldersFirst', style);

  static bool? get searchInsideHidden =>
      HiveBox.prefsBox.get('searchInsideHidden', defaultValue: false) as bool?;
  static set searchInsideHidden(bool? flag) =>
      HiveBox.prefsBox.put('searchInsideHidden', flag);

  static bool? get copyOnDrop =>
      HiveBox.prefsBox.get('copyOnDrop', defaultValue: false) as bool?;
  static set copyOnDrop(bool? flag) => HiveBox.prefsBox.put('copyOnDrop', flag);

  static bool? get replaceOnDrop =>
      HiveBox.prefsBox.get('replaceOnDrop', defaultValue: false) as bool?;
  static set replaceOnDrop(bool? flag) =>
      HiveBox.prefsBox.put('replaceOnDrop', flag);
}

class BrowserUtils {
  static DirectoryListingSpec spec({
    required ServerFile? serverFile,
    bool recursive = false,
    bool directoryCounts = false,
  }) {
    final bool? searchHiddenDirs = BrowserPrefs.searchInsideHidden;
    final String? sortType = BrowserPrefs.sortType;
    final bool? showHidden = BrowserPrefs.showHidden;
    final bool? sortAscending = BrowserPrefs.sortAscending;
    final bool? sortFoldersFirst = BrowserPrefs.sortFoldersFirst;

    return DirectoryListingSpec(
      serverFile: serverFile,
      recursive: recursive,
      directoryCounts: directoryCounts,
      sortType: sortType,
      sortAscending: sortAscending,
      sortFoldersFirst: sortFoldersFirst,
      showHidden: showHidden,
      searchHiddenDirs: searchHiddenDirs,
    );
  }
}

class SortTypes {
  SortTypes({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  // constants
  static const String sortByName = 'name';
  static const String sortBySize = 'size';
  static const String sortByDate = 'date';
  static const String sortByKind = 'kind';

  static List<SortTypes> sortTypes = <SortTypes>[
    SortTypes(id: SortTypes.sortByName, name: 'Name'),
    SortTypes(id: SortTypes.sortBySize, name: 'Size'),
    SortTypes(id: SortTypes.sortByDate, name: 'Date'),
    SortTypes(id: SortTypes.sortByKind, name: 'Kind'),
  ];
}
