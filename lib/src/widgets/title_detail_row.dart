import 'package:flutter/material.dart';

class TitleDetailRow extends StatelessWidget {
  const TitleDetailRow({
    this.title,
    this.detail,
    this.fontSize,
    this.oneLine = false,
  });

  final String? title;
  final String? detail;
  final double? fontSize;
  final bool oneLine;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: fontSize ?? 16,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              detail ?? '',
              maxLines: oneLine ? 1 : null,
              overflow: oneLine ? TextOverflow.ellipsis : null,
              softWrap: false,
              style: TextStyle(
                fontSize: fontSize ?? 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
