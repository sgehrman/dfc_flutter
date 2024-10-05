// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_media_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WpMediaDetailsModel _$WpMediaDetailsModelFromJson(Map<String, dynamic> json) =>
    WpMediaDetailsModel(
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      filesize: json['filesize'] as int? ?? 0,
      file: json['file'] as String? ?? '',
      sizes: (json['sizes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, WpMediaSizeModel.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$WpMediaDetailsModelToJson(
        WpMediaDetailsModel instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'filesize': instance.filesize,
      'file': instance.file,
      'sizes': instance.sizes.map((k, e) => MapEntry(k, e.toJson())),
    };
