import 'package:json_annotation/json_annotation.dart';

part 'wp_media_size_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WpMediaSizeModel {
  WpMediaSizeModel({
    this.width = 0,
    this.height = 0,
    this.filesize = 0,
    this.file = '',
    this.mimeType = '',
    this.sourceUrl = '',
  });

  factory WpMediaSizeModel.fromJson(Map<String, dynamic> json) =>
      _$WpMediaSizeModelFromJson(json);

  final int width;
  final int height;
  final int filesize;
  final String file;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @JsonKey(name: 'source_url')
  final String sourceUrl;

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$WpMediaSizeModelToJson(this);
}
