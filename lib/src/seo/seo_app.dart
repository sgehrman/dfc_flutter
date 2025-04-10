import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoApp extends StatelessWidget {
  const SeoApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SeoController(tree: WidgetTree(context: context), child: child);
  }
}
