import 'package:dfc_flutter/l10n/app_localizations.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_data.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_dialog_search_widget.dart';
import 'package:dfc_flutter/src/help_dialog_widget/help_list.dart';
import 'package:dfc_flutter/src/widgets/filter_field.dart';
import 'package:dfc_flutter/src/widgets/paragraf.dart';
import 'package:flutter/material.dart';

class HelpDialogWidget extends StatelessWidget {
  const HelpDialogWidget({
    required this.data,
    required this.isMobile,
    this.title,
  });

  final List<HelpData> data;
  final bool isMobile;
  final ParagrafSpec? title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Paragraf(
                specs: [
                  title!,
                ],
                isMobile: isMobile,
              ),
            ),
            const SizedBox(height: 20),
          ],
          HelpList(
            helpData: data,
            isMobile: isMobile,
          ),
        ],
      ),
    );
  }
}

// ===================================================================

class HelpDialogContents extends StatelessWidget {
  const HelpDialogContents({
    required this.query,
    required this.data,
    required this.title,
    required this.isMobile,
  });

  final ValueNotifier<String> query;
  final bool isMobile;
  final List<HelpData> data;
  final ParagrafSpec? title;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: query,
      builder: (context, filter, _) {
        if (filter.length > 1) {
          return Flexible(
            child: SizedBox(
              height: 1000,
              child: HelpDialogSearchWidget(
                filter: filter,
                data: data,
                isMobile: isMobile,
              ),
            ),
          );
        }

        return HelpDialogWidget(
          data: data,
          title: title,
          isMobile: isMobile,
        );
      },
    );
  }
}

// ===================================================================

class HelpDialogSearchField extends StatefulWidget {
  const HelpDialogSearchField({
    required this.query,
  });

  final ValueNotifier<String> query;

  @override
  State<HelpDialogSearchField> createState() => _HelpDialogSearchFieldState();
}

class _HelpDialogSearchFieldState extends State<HelpDialogSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 150,
        child: FilterField(
          small: true,
          controller: _controller,
          hint: l10n.search,
          onChange: (filter) {
            widget.query.value = filter;
          },
          onSubmit: (filter) {
            // ddd
          },
        ),
      ),
    );
  }
}
