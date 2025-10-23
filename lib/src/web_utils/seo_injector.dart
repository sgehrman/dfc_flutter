import 'package:dfc_flutter/src/web_utils/web_utils.dart';
import 'package:flutter/material.dart';

class SeoInjector extends StatefulWidget {
  const SeoInjector(
      {required this.child,
      required this.html,
      required this.enabled,
      super.key});

  final Widget child;
  final String html;
  final bool enabled;

  @override
  State<SeoInjector> createState() => _SeoInjectorState();
}

class _SeoInjectorState extends State<SeoInjector> {
  @override
  void initState() {
    super.initState();

    if (widget.enabled) {
      _updateBody(widget.html);
    }
  }

  void _updateBody(String html) {
    WebUtils().injectSeo(html);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
