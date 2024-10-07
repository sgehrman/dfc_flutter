import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_flutter/src/blog_dialog/blog_html_widget.dart';
import 'package:flutter/material.dart';

class BlogPostList extends StatelessWidget {
  const BlogPostList({
    required this.postRecords,
    required this.onClick,
    required this.onLoadMore,
    required this.isMobile,
  });

  final List<WpPostRecord> postRecords;
  final void Function(WpPostRecord rec) onClick;
  final bool Function() onLoadMore;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 200),
      itemCount: postRecords.length + 1,
      itemBuilder: (context, index) {
        if (index >= postRecords.length) {
          final bool loading = onLoadMore();

          if (loading) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: LoadingWidget(
                color: context.primary,
                delay: const Duration(milliseconds: 100),
                size: 42,
              ),
            );
          }

          return const SizedBox();
        }

        final rec = postRecords[index];
        final thumbnail = rec.mediaLinks.thumbnail();

        final htmlString = rec.post.html(
          excerptOnly: true,
          isMobile: isMobile,
        );

        return Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              onClick(rec);
            },
            child: Row(
              children: [
                if (thumbnail.isNotEmpty) ...[
                  Image.network(
                    thumbnail,
                    height: isMobile ? 140 : 200,
                    width: isMobile ? 140 : 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
                Expanded(
                  child: BlogHtmlWidget(
                    htmlString: htmlString,
                    isMobile: isMobile,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
