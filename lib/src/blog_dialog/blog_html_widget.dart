import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class BlogHtmlWidget extends StatelessWidget {
  const BlogHtmlWidget({
    required this.htmlString,
    required this.isMobile,
  });
  final String htmlString;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlString,
      customStylesBuilder: (element) {
        if (element.classes.contains('has-text-align-center')) {
          return {'text-align': 'center'};
        }

        if (element.classes.contains('is-layout-flex')) {
          if (element.classes.contains('is-content-justification-center')) {
            return {
              'text-align': 'center',
            };
          }
        }

        // used in images
        if (element.classes.contains('aligncenter')) {
          return {
            'text-align': 'center',
          };
        }

        return null;
      },
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      textStyle: TextStyle(fontSize: isMobile ? 14 : 18),
    );
  }
}
