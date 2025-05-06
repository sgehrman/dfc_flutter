import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:dfc_flutter/src/blog_dialog/blog_html_widget.dart';
import 'package:flutter/material.dart';

class BlogPostWidget extends StatelessWidget {
  const BlogPostWidget({
    required this.postRecord,
    required this.onBackButton,
    required this.isMobile,
  });

  final WpPostRecord? postRecord;
  final Function() onBackButton;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (postRecord == null) {
      return const NothingWidget();
    }

    final thumbnail = postRecord!.mediaLinks.thumbnail(maxSize: 1200);

    final horizPadding = isMobile ? 20.0 : 40.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.only(
            bottom: 200,
          ),
          children: [
            if (thumbnail.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                height: constraints.maxWidth / 4,
                child: Image.network(thumbnail, fit: BoxFit.cover),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizPadding),
              child: BlogHtmlWidget(
                htmlString: postRecord!.post.html(
                  excerptOnly: false,
                  isMobile: isMobile,
                ),
                isMobile: isMobile,
              ),
            ),
          ],
        );
      },
    );
  }
}
