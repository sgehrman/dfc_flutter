import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icons.dart';
import 'package:flutter/material.dart';

class SvgScreen extends StatelessWidget {
  const SvgScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = SvgIcons.everyIcon;

    return Scaffold(
      backgroundColor: Colors.grey,
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisExtent: 150,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return SvgIcon(
            icons[index],
            size: 50,
            color: Colors.red.withOpacity(.9),
          );
        },
      ),
    );
  }
}
