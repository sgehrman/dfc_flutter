// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wp_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WpPostModel _$WpPostModelFromJson(Map<String, dynamic> json) => WpPostModel(
      id: json['id'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      title:
          json['title'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      excerpt:
          json['excerpt'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      date: json['date'] as String? ?? '',
      content:
          json['content'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      links:
          json['_links'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$WpPostModelToJson(WpPostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'content': instance.content,
      'excerpt': instance.excerpt,
      'date': instance.date,
      '_links': instance.links,
    };
