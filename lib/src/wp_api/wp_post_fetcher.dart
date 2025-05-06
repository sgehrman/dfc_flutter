import 'dart:async';

import 'package:dfc_flutter/src/wp_api/wp_post_page.dart';

class WpPostFetcher {
  WpPostFetcher({required this.hostUrl});

  final String hostUrl;
  final List<WpPostPage> _pages = [];
  int _nextPage = 1;

  bool hasMore() {
    var result = true;

    if (_pages.isNotEmpty) {
      result = _pages.last.hasMore();
    }

    return result;
  }

  Future<List<WpPostRecord>> posts() async {
    if (hasMore()) {
      final page = WpPostPage(hostUrl: hostUrl, page: _nextPage++);
      _pages.add(page);
    }

    final result = <WpPostRecord>[];

    for (final p in _pages) {
      result.addAll(await p.postRecords());
    }

    return result;
  }
}
