import 'package:flutter/material.dart';

class ThumbsUpControl extends StatefulWidget {
  const ThumbsUpControl({
    required this.value,
    required this.onChanged,
    this.iconSize = 32,
  });

  // or null if not set
  final bool? value;

  // pass null to disable
  final ValueChanged<bool?>? onChanged;
  final double iconSize;

  @override
  State<ThumbsUpControl> createState() => _ThumbsUpControlState();
}

class _ThumbsUpControlState extends State<ThumbsUpControl> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onChanged == null
                ? null
                : () {
                    bool? newResult;

                    switch (widget.value) {
                      case true:
                        break;
                      case false:
                      case null:
                        newResult = true;
                    }

                    widget.onChanged?.call(newResult);

                    setState(() {});
                  },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _ThumbWidget(
                selected: widget.value ?? false,
                upThumb: true,
                iconSize: widget.iconSize,
                disabled: widget.onChanged == null,
              ),
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          clipBehavior: Clip.antiAlias,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: widget.onChanged == null
                ? null
                : () {
                    bool? newResult;

                    switch (widget.value) {
                      case false:
                        break;
                      case true:
                      case null:
                        newResult = false;
                    }

                    widget.onChanged?.call(newResult);

                    setState(() {});
                  },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _ThumbWidget(
                selected: widget.value == false,
                upThumb: false,
                iconSize: widget.iconSize,
                disabled: widget.onChanged == null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ==============================================================

class _ThumbWidget extends StatelessWidget {
  const _ThumbWidget({
    required this.upThumb,
    required this.selected,
    this.iconSize = 32,
    this.disabled = false,
  });

  final bool upThumb;
  final bool selected;
  final double iconSize;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    const unselectedColor = Color.fromRGBO(180, 180, 180, 1);

    IconData icon;
    IconData outlinedIcon;

    Color? iconColor;

    if (!upThumb) {
      icon = Icons.thumb_down;
      outlinedIcon = Icons.thumb_down;

      iconColor = Colors.red[600];
    } else {
      icon = Icons.thumb_up;
      outlinedIcon = Icons.thumb_up;

      iconColor = Colors.green[600];
    }

    final firstIconColor = selected ? iconColor : unselectedColor;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Icon(
        selected ? icon : outlinedIcon,
        color: firstIconColor,
        size: iconSize,
      ),
    );
  }
}
