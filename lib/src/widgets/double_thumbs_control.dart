import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/widgets/thumb_widget.dart';

class DoubleThumbsControl extends StatefulWidget {
  const DoubleThumbsControl({
    required this.value,
    required this.onChanged,
    this.showText = true,
  });

  // or null if not set
  final int? value; // 0-3
  final ValueChanged<int?> onChanged;
  final bool showText;

  @override
  _DoubleThumbsControlState createState() => _DoubleThumbsControlState();
}

class _DoubleThumbsControlState extends State<DoubleThumbsControl> {
  Widget _thumb(int index) {
    return InkWell(
      onTap: () {
        int? newResult;

        if (widget.value != index) {
          newResult = index;
        }

        widget.onChanged(newResult);

        setState(() {});
      },
      child: ThumbWidget(
        index: index,
        selectedIndex: widget.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String textResult = 'Select Rating';

    switch (widget.value) {
      case 0:
        textResult = 'Strong No';
        break;
      case 1:
        textResult = 'No';
        break;
      case 2:
        textResult = 'Yes';
        break;
      case 3:
        textResult = 'Strong Yes';
        break;
    }

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _thumb(0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _thumb(1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _thumb(2),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _thumb(3),
            ),
          ],
        ),
        Visibility(
          visible: widget.showText,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  textResult,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
