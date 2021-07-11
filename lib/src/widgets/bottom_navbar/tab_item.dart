import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const double iconOff = -3;
const double iconOn = 0;
const double textOff = 3;
const double textOn = 1;
const double alphaOff = 0;
const double alphaOn = 1;
const int animDuration = 400;

class TabItem extends StatelessWidget {
  const TabItem(
      {required this.uniqueKey,
      required this.selected,
      required this.iconData,
      required this.title,
      required this.callbackFunction,
      required this.textColor,
      required this.iconColor,
      this.gradient});

  final UniqueKey uniqueKey;
  final String title;
  final IconData iconData;
  final bool selected;
  final Function(UniqueKey uniqueKey) callbackFunction;
  final Color? textColor;
  final Color? iconColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: animDuration),
              alignment: Alignment(0, selected ? textOn : textOff),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style:
                      TextStyle(fontWeight: FontWeight.w600, color: textColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: animDuration),
              curve: Curves.easeIn,
              alignment: Alignment(0, selected ? iconOff : iconOn),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: animDuration),
                opacity: selected ? alphaOff : alphaOn,
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  padding: const EdgeInsets.all(0),
                  icon: gradient != null
                      ? ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return ui.Gradient.linear(const Offset(4.0, 24.0),
                                const Offset(24.0, 4.0), gradient!.colors);
                          },
                          child: Icon(iconData),
                        )
                      : Icon(
                          iconData,
                          color: iconColor,
                        ),
                  onPressed: () {
                    callbackFunction(uniqueKey);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
