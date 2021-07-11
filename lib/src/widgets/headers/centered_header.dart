import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/themes/editor/theme_set_manager.dart';

class CenteredHeader extends StatelessWidget {
  const CenteredHeader(this.header, {this.top, this.bottom});

  final String header;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? 4, top: top ?? 10),
      child: Text(
        header,
        textAlign: TextAlign.center,
        style: ThemeSetManager.header(context),
      ),
    );
  }
}
