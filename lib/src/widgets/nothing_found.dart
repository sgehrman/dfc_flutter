import 'package:dfc_flutter/l10n/app_localizations.dart';
import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
// import 'package:localizations/localizations.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({
    this.nothing = true,
    this.loading = false,
    this.message = '', // 'Nothing found'
    this.fontSize = 14,
    this.bold = false,
  });

  final bool nothing;
  final bool loading;
  final String message;
  final double fontSize;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    Widget? contents;

    if (loading) {
      contents = LoadingWidget(
        color: context.primary,
        size: 24,
      );
    } else if (nothing) {
      final msg = message.isEmpty ? l10n.nothingFound : message;

      contents = Center(
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.dimTextColor,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    }

    if (contents != null) {
      // be sure to ignore mouse so it doesn't interfere with drag and drops
      return IgnorePointer(child: contents);
    }

    return const NothingWidget();
  }
}
