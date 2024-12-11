import 'package:dfc_flutter/src/extensions/string_ext.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    this.maxLength = 80,
    this.style,
  });

  final int maxLength;
  final String? text;
  final TextStyle? style;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(widget.text)) {
      final truncNotes =
          expanded ? widget.text! : widget.text!.truncate(widget.maxLength);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            truncNotes,
            overflow: TextOverflow.ellipsis,
            softWrap: false, // need this?
            style: widget.style ?? Theme.of(context).textTheme.bodySmall,
            // we use truncate above to control size
            // otherwise won't get ... on line breaks that don't hit the end
            // maxlines does help limit an extremely long string, but nothing else
            maxLines: 200,
          ),
          Visibility(
            visible: widget.text!.length > widget.maxLength,
            child: InkWell(
              onTap: () {
                expanded = !expanded;

                setState(() {});
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  expanded ? 'Show less' : 'Show more',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.8),
                      ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const NothingWidget();
  }
}
