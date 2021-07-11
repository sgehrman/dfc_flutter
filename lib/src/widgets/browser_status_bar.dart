import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

class BrowserStatusBar extends StatelessWidget {
  const BrowserStatusBar({
    required this.status,
    required this.callback,
    this.locked,
    this.web = false,
  });

  final String status;
  final void Function(String action) callback;
  final bool web;
  final bool? locked;

  @override
  Widget build(BuildContext context) {
    if (web) {
      return Container(
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .primaryColor, // Utils.darken(Theme.of(context).primaryColor, .10),
        ),
        // color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (locked == true) // could be null
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Entypo.lock,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .scaffoldBackgroundColor, // Utils.darken(Theme.of(context).primaryColor, .10),
        boxShadow: [
          BoxShadow(
            color: Utils.isDarkMode(context)
                ? const Color(0x50000000)
                : const Color(0x60000000),
            blurRadius: 4,
            // offset: Offset(0, 0),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Text(
                status,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned.fill(
            left: null,
            right: 14,
            child: InkWell(
              onTap: () {
                callback('');
              },
              child: const Icon(Icons.more_horiz),
            ),
          ),
          if (locked == true) // could be null
            const Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Entypo.lock,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
