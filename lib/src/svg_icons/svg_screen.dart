import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icons.dart';
import 'package:flutter/material.dart';

class SvgScreen extends StatelessWidget {
  const SvgScreen({
    this.color = Colors.grey,
    this.size = 50,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    const icons = SvgIcons.everyIcon;

    return Scaffold(
      appBar: AppBar(title: const Text('SVG Icons')),
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
            size: size,
            color: color,
          );
        },
      ),
    );
  }
}
