import 'package:dfc_flutter/src/hive_db/hive_box.dart';
import 'package:flutter/material.dart';

class HiveOpener extends StatefulWidget {
  const HiveOpener({required this.child, required this.box});

  final Widget child;
  final HiveBox<dynamic> box;

  @override
  _HiveOpenerState createState() => _HiveOpenerState();
}

class _HiveOpenerState extends State<HiveOpener> {
  @override
  void dispose() {
    // close box on dispose
    widget.box.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.box.open(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return widget.child;
          }
        } else {
          return Container();
        }
      },
    );
  }
}
