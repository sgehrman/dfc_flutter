// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManifestModel _$ManifestModelFromJson(Map<String, dynamic> json) {
  return ManifestModel(
    items: (json['items'] as List<dynamic>)
        .map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ManifestModelToJson(ManifestModel instance) =>
    <String, dynamic>{
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    assets: (json['assets'] as List<dynamic>)
        .map((e) => Asset.fromJson(e as Map<String, dynamic>))
        .toList(),
    metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'assets': instance.assets,
      'metadata': instance.metadata,
    };

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
    kind: json['kind'] as String,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'kind': instance.kind,
      'url': instance.url,
    };

Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  return Metadata(
    bundleIdentifier: json['bundleIdentifier'] as String,
    bundleVersion: json['bundleVersion'] as String,
    kind: json['kind'] as String,
    platformIdentifier: json['platformIdentifier'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$MetadataToJson(Metadata instance) => <String, dynamic>{
      'bundleIdentifier': instance.bundleIdentifier,
      'bundleVersion': instance.bundleVersion,
      'kind': instance.kind,
      'platformIdentifier': instance.platformIdentifier,
      'title': instance.title,
    };
