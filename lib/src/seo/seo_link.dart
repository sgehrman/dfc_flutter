import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoLink extends StatelessWidget {
  const SeoLink({
    required this.title,
    required this.href,
    required this.child,
    super.key,
    this.rel,
  });
  final String title;
  final String href;
  final String? rel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Seo.link(anchor: title, href: href, rel: rel, child: child);
  }
}
