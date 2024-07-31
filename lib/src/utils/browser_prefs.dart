import 'package:dfc_flutter/src/file_system/directory_listing_spec.dart';
import 'package:dfc_flutter/src/file_system/server_file.dart';
import 'package:dfc_flutter/src/hive_db/hive_utils.dart';

class BrowserPrefs {
  static bool? get showHidden =>
      PrefsBox().box.get('showHidden', defaultValue: false) as bool?;
  static set showHidden(bool? flag) => PrefsBox().box.put('showHidden', flag);

  static String? get sortType =>
      PrefsBox().box.get('sortType', defaultValue: SortTypes.sortByName)
          as String?;
  static set sortType(String? style) => PrefsBox().box.put('sortType', style);

  static bool? get sortAscending =>
      PrefsBox().box.get('sortAscending', defaultValue: true) as bool?;
  static set sortAscending(bool? style) =>
      PrefsBox().box.put('sortAscending', style);

  static bool? get sortFoldersFirst =>
      PrefsBox().box.get('sortFoldersFirst', defaultValue: true) as bool?;
  static set sortFoldersFirst(bool? style) =>
      PrefsBox().box.put('sortFoldersFirst', style);

  static bool? get searchInsideHidden =>
      PrefsBox().box.get('searchInsideHidden', defaultValue: false) as bool?;
  static set searchInsideHidden(bool? flag) =>
      PrefsBox().box.put('searchInsideHidden', flag);

  static bool? get copyOnDrop =>
      PrefsBox().box.get('copyOnDrop', defaultValue: false) as bool?;
  static set copyOnDrop(bool? flag) => PrefsBox().box.put('copyOnDrop', flag);

  static bool? get replaceOnDrop =>
      PrefsBox().box.get('replaceOnDrop', defaultValue: false) as bool?;
  static set replaceOnDrop(bool? flag) =>
      PrefsBox().box.put('replaceOnDrop', flag);
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
