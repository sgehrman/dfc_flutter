// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_media_size_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WpMediaSizeModel _$WpMediaSizeModelFromJson(Map<String, dynamic> json) =>
    WpMediaSizeModel(
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      filesize: json['filesize'] as int? ?? 0,
      file: json['file'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      sourceUrl: json['source_url'] as String? ?? '',
    );

Map<String, dynamic> _$WpMediaSizeModelToJson(WpMediaSizeModel instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'filesize': instance.filesize,
      'file': instance.file,
      'mime_type': instance.mimeType,
      'source_url': instance.sourceUrl,
    };
