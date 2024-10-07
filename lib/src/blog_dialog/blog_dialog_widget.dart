import 'dart:async';

import 'package:dfc_flutter/src/blog_dialog/blog_post_list.dart';
import 'package:dfc_flutter/src/blog_dialog/blog_post_widget.dart';
import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/widgets/dialog_back_button_controller.dart';
import 'package:dfc_flutter/src/widgets/loading_widget.dart';
import 'package:dfc_flutter/src/wp_api/wp_post_fetcher.dart';
import 'package:dfc_flutter/src/wp_api/wp_post_page.dart';
import 'package:flutter/material.dart';

enum _DialogMode {
  list,
  post,
}

// ===========================================================

class BlogDialogWidget extends StatefulWidget {
  const BlogDialogWidget({
    required this.hostUrl,
    required this.isMobile,
    required this.backButtonController,
    required this.titleNotifier,
    required this.postId,
  });

  final String hostUrl;
  final bool isMobile;
  final DialogBackButtonController? backButtonController;
  final ValueNotifier<String> titleNotifier;
  final String postId;

  @override
  State<BlogDialogWidget> createState() => __BlogDialogWidgetState();
}

class __BlogDialogWidgetState extends State<BlogDialogWidget> {
  _DialogMode _mode = _DialogMode.list;
  final List<WpPostRecord> _postRecords = [];
  WpPostRecord? _selectedPost;
  late final WpPostFetcher _fetcher;

  @override
  void initState() {
    super.initState();

    _setup();
  }

  Future<void> _setup() async {
    _fetcher = WpPostFetcher(hostUrl: widget.hostUrl);

    await _updatePosts();

    if (widget.postId.isNotEmpty) {
      for (final post in _postRecords) {
        if (widget.postId == post.post.id.toString()) {
          _switchToPost(post);
          break;
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updatePosts() async {
    if (_fetcher.hasMore()) {
      final recs = await _fetcher.posts();

      _postRecords.clear();
      _postRecords.addAll(recs);

      if (mounted) {
        setState(() {});
      }
    }
  }

  bool _onLoadMore() {
    if (_fetcher.hasMore()) {
      _updatePosts();

      return true;
    }

    return false;
  }

  void _switchToList() {
    _mode = _DialogMode.list;
    widget.backButtonController?.onPressed = null;
    widget.titleNotifier.value = 'Path Finder Blog';

    setState(() {});
  }

  void _switchToPost(WpPostRecord post) {
    _selectedPost = post;
    _mode = _DialogMode.post;
    widget.titleNotifier.value = post.post.titleString;

    widget.backButtonController?.onPressed = () {
      _switchToList();
    };

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const double contentHeight = 800;

    if (_postRecords.isEmpty) {
      return SizedBox(
        height: contentHeight,
        child: LoadingWidget(
          color: context.primary,
          delay: Duration.zero,
        ),
      );
    }

    switch (_mode) {
      case _DialogMode.list:
        return SizedBox(
          height: contentHeight,
          child: BlogPostList(
            postRecords: _postRecords,
            onClick: (rec) {
              _switchToPost(rec);
            },
            onLoadMore: _onLoadMore,
            isMobile: widget.isMobile,
          ),
        );
      case _DialogMode.post:
        return BlogPostWidget(
          postRecord: _selectedPost,
          onBackButton: _switchToList,
          isMobile: widget.isMobile,
        );
    }
  }
}
