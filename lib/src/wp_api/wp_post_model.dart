import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wp_post_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WpPostModel {
  WpPostModel({
    this.id = 0,
    this.type = '',
    this.title = const <String, dynamic>{},
    this.excerpt = const <String, dynamic>{},
    this.date = '',
    this.content = const <String, dynamic>{},
    this.links = const <String, dynamic>{},
  });

  factory WpPostModel.fromJson(Map<String, dynamic> json) =>
      _$WpPostModelFromJson(json);

  final int id;
  final String type;
  final Map<String, dynamic> title;
  final Map<String, dynamic> content;
  final Map<String, dynamic> excerpt;
  final String date;

  @JsonKey(name: '_links')
  final Map<String, dynamic> links;

  String get titleString {
    return title['rendered'] as String? ?? '';
  }

  String get contentString {
    return content['rendered'] as String? ?? '';
  }

  String get exerptString {
    return excerpt['rendered'] as String? ?? '';
  }

  String get featuredMediaLink {
    final listJson = List<Map<String, dynamic>>.from(
      links['wp:featuredmedia'] as List? ?? [],
    );

    if (listJson.isNotEmpty) {
      return listJson.first['href'] as String? ?? '';
    }

    return '';
  }

  String html({
    required bool excerptOnly,
    required bool isMobile,
  }) {
    final buffer = StringBuffer();

    final dateStr = dateString();
    if (dateStr.isNotEmpty) {
      buffer.write(dateStr);
    }

    if (excerptOnly) {
      if (titleString.isNotEmpty) {
        buffer.write('<h3>$titleString</h3>');
      }

      buffer.write(exerptString.truncate(isMobile ? 100 : 200));
    } else {
      if (titleString.isNotEmpty) {
        buffer.write('<h1>$titleString</h1>');
      }

      buffer.write(contentString);
    }

    return buffer.toString();
  }

  String dateString() {
    String result = '';

    final d = DateTime.tryParse(date);
    if (d != null) {
      final formatted = DateFormat('EEE h:mm a').format(d);

      result = '<p style="color: gray;">$formatted</p>';
    }

    return result;
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$WpPostModelToJson(this);
}
