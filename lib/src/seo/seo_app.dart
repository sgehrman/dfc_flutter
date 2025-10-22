import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

class SeoApp extends StatelessWidget {
  const SeoApp({required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SeoController(
        tree: WidgetTree(context: context), enabled: enabled, child: child);
  }
}
