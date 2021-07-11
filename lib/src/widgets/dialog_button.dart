import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({this.onPressed, this.title, this.filled = false});

  final VoidCallback? onPressed;
  final String? title;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 130,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor:
              filled ? Theme.of(context).accentColor : Colors.white,
          // borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
        onPressed: onPressed,
        child: Text(
          title!,
          style: TextStyle(
            color: filled ? Colors.white : Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
