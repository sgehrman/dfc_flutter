// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_media_links_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WpMediaLinksModel _$WpMediaLinksModelFromJson(Map<String, dynamic> json) =>
    WpMediaLinksModel(
      mimeType: json['mime_type'] as String? ?? '',
      mediaType: json['media_type'] as String? ?? '',
      mediaDetails: json['media_details'] == null
          ? null
          : WpMediaDetailsModel.fromJson(
              json['media_details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WpMediaLinksModelToJson(WpMediaLinksModel instance) =>
    <String, dynamic>{
      'media_type': instance.mediaType,
      'mime_type': instance.mimeType,
      'media_details': instance.mediaDetails?.toJson(),
    };
