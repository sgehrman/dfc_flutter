import 'package:dfc_flutter/src/wp_api/wp_media_details_model.dart';
import 'package:dfc_flutter/src/wp_api/wp_media_size_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wp_media_links_model.g.dart';

@JsonSerializable(
  explicitToJson: true,
)
class WpMediaLinksModel {
  WpMediaLinksModel({
    this.mimeType = '',
    this.mediaType = '',
    this.mediaDetails,
  });

  factory WpMediaLinksModel.fromJson(Map<String, dynamic> json) =>
      _$WpMediaLinksModelFromJson(json);

  @JsonKey(name: 'media_type')
  final String mediaType;

  @JsonKey(name: 'mime_type')
  final String mimeType;

  @JsonKey(name: 'media_details')
  final WpMediaDetailsModel? mediaDetails;

  String thumbnail({int maxSize = 256}) {
    if (mediaDetails != null) {
      if (mediaDetails!.sizes.isNotEmpty) {
        final sizeMap = mediaDetails!.sizes;

        final keys = sizeMap.keys;

        WpMediaSizeModel? bestMatch;

        for (final key in keys) {
          final size = sizeMap[key];

          if (size != null) {
            if (bestMatch != null) {
              final oldDiff = (bestMatch.width - maxSize).abs();
              final newDiff = (size.width - maxSize).abs();

              if (newDiff < oldDiff) {
                bestMatch = size;
              }
            } else {
              bestMatch = size;
            }
          }
        }

        if (bestMatch != null) {
          return bestMatch.sourceUrl;
        }
      }
    }

    return '';
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() => _$WpMediaLinksModelToJson(this);
}
