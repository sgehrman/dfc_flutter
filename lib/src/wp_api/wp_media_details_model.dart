import 'package:dfc_flutter/src/wp_api/wp_media_size_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wp_media_details_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WpMediaDetailsModel {
  WpMediaDetailsModel({
    this.width = 0,
    this.height = 0,
    this.filesize = 0,
    this.file = '',
    this.sizes = const {},
  });

  factory WpMediaDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$WpMediaDetailsModelFromJson(json);

  final int width;
  final int height;
  final int filesize;
  final String file;
  final Map<String, WpMediaSizeModel> sizes;

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$WpMediaDetailsModelToJson(this);
}
