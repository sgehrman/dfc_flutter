import 'package:dfc_flutter/src/svg_icons/svg_converter.dart';
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
    const iconNames = SvgIcons.iconNames;

    final actions = [
      IconButton(
        onPressed: () {
          svgConvert();
        },
        icon: const Icon(Icons.connected_tv_sharp),
      ),
    ];

    final gridItemWidth = size * 3;
    final gridItemHeight = gridItemWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Icons'),
        actions: actions,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth ~/ gridItemWidth,
              mainAxisExtent: gridItemHeight,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: icons.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  SvgIcon(
                    icons[index],
                    size: size,
                    color: color,
                  ),
                  const SizedBox(height: 10),
                  Text(iconNames[index]),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
