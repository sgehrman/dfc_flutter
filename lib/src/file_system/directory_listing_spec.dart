import 'dart:convert';

import 'package:dfc_flutter/src/file_system/server_file.dart';

class DirectoryListingSpec {
  DirectoryListingSpec({
    required this.serverFile,
    required this.recursive,
    required this.sortType,
    required this.sortAscending,
    required this.sortFoldersFirst,
    required this.showHidden,
    required this.searchHiddenDirs,
    required this.directoryCounts,
  });

  factory DirectoryListingSpec.fromMap(Map<String, dynamic> map) {
    return DirectoryListingSpec(
      serverFile: ServerFile.fromMap(map['serverFile'] as Map<String, dynamic>),
      recursive: map['recursive'] as bool?,
      sortType: map['sortType'] as String?,
      sortAscending: map['sortAscending'] as bool?,
      sortFoldersFirst: map['sortFoldersFirst'] as bool?,
      showHidden: map['showHidden'] as bool?,
      searchHiddenDirs: map['searchHiddenDirs'] as bool?,
      directoryCounts: map['directoryCounts'] as bool?,
    );
  }

  factory DirectoryListingSpec.fromJson(String source) =>
      DirectoryListingSpec.fromMap(json.decode(source) as Map<String, dynamic>);

  final ServerFile serverFile;
  final bool? recursive;
  final String? sortType;
  final bool? sortAscending;
  final bool? sortFoldersFirst;
  final bool? showHidden;
  final bool? searchHiddenDirs;
  final bool? directoryCounts;

  bool shouldRebuildForNewSpec(DirectoryListingSpec otherSpec) {
    return sortType != otherSpec.sortType ||
        showHidden != otherSpec.showHidden ||
        sortAscending != otherSpec.sortAscending ||
        sortFoldersFirst != otherSpec.sortFoldersFirst ||
        searchHiddenDirs != otherSpec.searchHiddenDirs;
  }

  DirectoryListingSpec copyWith({
    ServerFile? serverFile,
    bool? recursive,
    String? sortType,
    bool? sortFoldersFirst,
    bool? sortAscending,
    bool? showHidden,
    bool? searchHiddenDirs,
    bool? directoryCounts,
  }) {
    return DirectoryListingSpec(
      serverFile: serverFile ?? this.serverFile,
      recursive: recursive ?? this.recursive,
      sortType: sortType ?? this.sortType,
      sortFoldersFirst: sortFoldersFirst ?? this.sortFoldersFirst,
      sortAscending: sortAscending ?? this.sortAscending,
      showHidden: showHidden ?? this.showHidden,
      searchHiddenDirs: searchHiddenDirs ?? this.searchHiddenDirs,
      directoryCounts: directoryCounts ?? this.directoryCounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverFile': serverFile.toMap(),
      'recursive': recursive,
      'sortType': sortType,
      'sortFoldersFirst': sortFoldersFirst,
      'sortAscending': sortAscending,
      'showHidden': showHidden,
      'searchHiddenDirs': searchHiddenDirs,
      'directoryCounts': directoryCounts,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'DirectoryListingSpec(serverFile: $serverFile, recursive: $recursive, sortType: $sortType, showHidden: $showHidden, '
        'searchHiddenDirs: $searchHiddenDirs, directoryCounts: $directoryCounts, sortFoldersFirst: $sortFoldersFirst, sortAscending: $sortAscending)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DirectoryListingSpec &&
        other.serverFile == serverFile &&
        other.recursive == recursive &&
        other.sortType == sortType &&
        other.sortFoldersFirst == sortFoldersFirst &&
        other.sortAscending == sortAscending &&
        other.showHidden == showHidden &&
        other.searchHiddenDirs == searchHiddenDirs &&
        other.directoryCounts == directoryCounts;
  }

  @override
  int get hashCode {
    return serverFile.hashCode ^
        recursive.hashCode ^
        sortType.hashCode ^
        sortFoldersFirst.hashCode ^
        sortAscending.hashCode ^
        showHidden.hashCode ^
        searchHiddenDirs.hashCode ^
        directoryCounts.hashCode;
  }
}
