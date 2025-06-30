import 'package:dfc_flutter/dfc_flutter_web.dart';
import 'package:flutter/material.dart';

class KeyValueTableRow {
  const KeyValueTableRow({
    required this.name,
    required this.value,
    this.color,
    this.fontSize = 14,
    this.valueColor,
    this.valueFontSize = 14,
    this.valueMaxLines = 4,
    this.valueIsUrl = false,
    this.valueTextAlign,
  });

  final String name;
  final Color? color;
  final double fontSize;
  final bool valueIsUrl;

  final String value;
  final Color? valueColor;
  final double valueFontSize;
  final int valueMaxLines;
  final TextAlign? valueTextAlign;
}

class KeyValueTable extends StatelessWidget {
  const KeyValueTable({
    required this.tableRows,
    this.defaultVerticalAlignment = TableCellVerticalAlignment.top,
    this.spaceBetweenRows = 4,
  });

  final List<KeyValueTableRow> tableRows;
  final TableCellVerticalAlignment defaultVerticalAlignment;
  final double spaceBetweenRows;

  @override
  Widget build(BuildContext context) {
    const height = 1.1;

    final children = tableRows.map((e) {
      final valueWidget = e.valueIsUrl
          ? TextWithLinks(
              e.value,
              textAlign: e.valueTextAlign,
              style: TextStyle(
                color: e.color,
                fontSize: e.valueFontSize,
                height: height,
              ),
            )
          : TextWithSize(
              e.value,
              textAlign: e.valueTextAlign,
              e.valueFontSize,
              color: e.valueColor,
              maxLines: e.valueMaxLines,
              height: height,
            );

      return TableRow(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: spaceBetweenRows),
            alignment: Alignment.centerLeft,
            child: TextWithSize(
              '${e.name}:',
              e.fontSize,
              color: e.color,
              height: height,
            ),
          ),
          const SizedBox(),
          Padding(
            padding: EdgeInsets.only(bottom: spaceBetweenRows),
            child: valueWidget,
          ),
        ],
      );
    }).toList();

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FractionColumnWidth(0.35),
        1: FixedColumnWidth(16), // space between
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: defaultVerticalAlignment,
      children: children,
    );
  }
}
