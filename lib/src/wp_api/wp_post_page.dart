import 'dart:async';
import 'dart:convert';

import 'package:dfc_flutter/src/wp_api/wp_media_links_model.dart';
import 'package:dfc_flutter/src/wp_api/wp_post_model.dart';
import 'package:http/http.dart' as http;

class WpPostRecord {
  WpPostRecord({required this.post, required this.mediaLinks});

  final WpPostModel post;
  final WpMediaLinksModel mediaLinks;
}

// ====================================================

class WpPostPage {
  WpPostPage({
    required this.hostUrl,
    this.page = 1,
  });

  final int page;
  final String hostUrl;

  Completer<List<WpPostRecord>>? _completer;
  String _numPosts = '0';
  String _numPages = '0';
  final String _numPerPage = '5';

  bool hasMore() {
    final numPages = int.parse(_numPages);

    return page < numPages;
  }

  int totalPosts() {
    return int.parse(_numPosts);
  }

  Future<List<WpPostRecord>> postRecords() async {
    if (_completer == null) {
      _completer = Completer<List<WpPostRecord>>();
      final List<WpPostRecord> result = [];

      // https://developer.wordpress.org/rest-api/reference/posts/
      final response = await http.get(
        Uri.parse(
          '$hostUrl/wp-json/wp/v2/posts?page=$page&per_page=$_numPerPage',
        ),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        _numPosts = response.headers['x-wp-total'] ?? '0';
        _numPages = response.headers['x-wp-totalpages'] ?? '0';

        final mapList = json.decode(response.body) as List? ?? [];

        final list = List<Map<String, dynamic>>.from(
          mapList,
        );

        final postModels = list.map((e) => WpPostModel.fromJson(e)).toList();

        // get media links for each model
        for (final post in postModels) {
          final links = await _mediaLinksModel(post);

          if (links != null) {
            result.add(WpPostRecord(post: post, mediaLinks: links));
          } else {
            print('### ERROR: post had no links? ${post.title}');
          }
        }

        _completer!.complete(result);
      }
    }

    return _completer!.future;
  }

  Future<WpMediaLinksModel?> _mediaLinksModel(WpPostModel post) async {
    if (post.featuredMediaLink.isNotEmpty) {
      final response = await http.get(
        Uri.parse(
          post.featuredMediaLink,
        ),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final map = Map<String, dynamic>.from(
          json.decode(response.body) as Map? ?? {},
        );

        return WpMediaLinksModel.fromJson(map);
      }
    }

    return null;
  }
}
