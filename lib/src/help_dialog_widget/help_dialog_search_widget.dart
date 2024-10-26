import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class HelpDialogSearchWidget extends StatefulWidget {
  const HelpDialogSearchWidget({
    required this.filter,
    required this.data,
    required this.isMobile,
  });

  final String filter;
  final List<HelpData> data;
  final bool isMobile;

  @override
  State<HelpDialogSearchWidget> createState() => _HelpDialogSearchWidgetState();
}

class _HelpDialogSearchWidgetState extends State<HelpDialogSearchWidget> {
  List<HelpData> _filtered = [];

  @override
  void initState() {
    super.initState();

    _update();
  }

  @override
  void didUpdateWidget(HelpDialogSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _update();
  }

  void _update() {
    _filtered = [];

    for (final item in widget.data) {
      final itemText = item.asText;

      if (itemText.contains(
        RegExp(
          widget.filter,
          caseSensitive: false,
        ),
      )) {
        _filtered.add(item);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_filtered.isEmpty) {
      return const NothingFound();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final item = _filtered[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Paragraf(
                isMobile: widget.isMobile,
                specs: [item.title],
              ),
              subtitle: Paragraf(
                isMobile: widget.isMobile,
                specs: [item.message],
              ),
            ),
          ),
        );
      },
    );
  }
}
