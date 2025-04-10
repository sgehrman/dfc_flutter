import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoHead extends StatelessWidget {
  const SeoHead({
    required this.title,
    required this.description,
    required this.child,
    super.key,
    this.author,
    this.canonicalUrl,
  });

  final String title;
  final String description;
  final String? author;
  final String? canonicalUrl;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Seo.head(
      tags: [
        MetaTag(name: 'title', content: title),
        MetaTag(name: 'description', content: description),
        if (author != null) ...[MetaTag(name: 'author', content: author)],
        if (canonicalUrl != null) ...[
          LinkTag(rel: 'canonical', href: canonicalUrl),
        ],
      ],
      child: child,
    );
  }
}
