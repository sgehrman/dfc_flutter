import 'package:json_annotation/json_annotation.dart';

part 'manifest_model.g.dart';

@JsonSerializable()
class ManifestModel {
  ManifestModel({
    required this.items,
  });

  factory ManifestModel.fromJson(Map<String, dynamic> json) =>
      _$ManifestModelFromJson(json);

  final List<Item> items;

  Map<String, dynamic> toJson() => _$ManifestModelToJson(this);
}

@JsonSerializable()
class Item {
  Item({
    required this.assets,
    required this.metadata,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  final List<Asset> assets;
  final Metadata metadata;

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Asset {
  Asset({
    required this.kind,
    required this.url,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

  final String kind;
  final String url;

  Map<String, dynamic> toJson() => _$AssetToJson(this);
}

@JsonSerializable()
class Metadata {
  Metadata({
    required this.bundleIdentifier,
    required this.bundleVersion,
    required this.kind,
    required this.platformIdentifier,
    required this.title,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);

  final String bundleIdentifier;
  final String bundleVersion;
  final String kind;
  final String platformIdentifier;
  final String title;

  Map<String, dynamic> toJson() => _$MetadataToJson(this);
}
