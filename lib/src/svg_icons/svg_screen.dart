import 'package:dfc_flutter/src/svg_icons/bootstrap_svgs.dart';
import 'package:dfc_flutter/src/svg_icons/material_svgs.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_bootstrap.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_material.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/search_field.dart';
import 'package:flutter/material.dart';

class SvgScreen extends StatefulWidget {
  const SvgScreen({
    this.color = Colors.grey,
    this.size = 50,
    this.materialSvgs = true,
  });

  final Color color;
  final double size;
  final bool materialSvgs;

  @override
  State<SvgScreen> createState() => _SvgScreenState();
}

class _SvgScreenState extends State<SvgScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    List<String> icons;
    List<String> iconNames;

    if (widget.materialSvgs) {
      icons = MaterialSvgs.everyIcon;
      iconNames = MaterialSvgs.iconNames;
    } else {
      icons = BootstrapSvgs.everyIcon;
      iconNames = BootstrapSvgs.iconNames;
    }

    final actions = [
      IconButton(
        onPressed: () {
          if (widget.materialSvgs) {
            materialConvert();
          } else {
            bootStrapConvert();
          }
        },
        icon: const Icon(Icons.connected_tv_sharp),
      ),
    ];

    final gridItemWidth = widget.size * 3;
    final gridItemHeight = gridItemWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Icons'),
        actions: actions,
      ),
      body: Column(
        children: [
          SearchField(
            onChange: (value) {
              _filter = value;
              setState(() {});
            },
            onSubmit: (value) {},
            hint: 'Filter',
            label: '',
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final List<_NameAndIcon> items = [];

                for (int i = 0; i < iconNames.length; i++) {
                  if (Utils.isNotEmpty(_filter)) {
                    if (iconNames[i].contains(_filter)) {
                      items.add(_NameAndIcon(iconNames[i], icons[i]));
                    }
                  } else {
                    items.add(_NameAndIcon(iconNames[i], icons[i]));
                  }
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth ~/ gridItemWidth,
                    mainAxisExtent: gridItemHeight,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        SvgIcon(
                          items[index].icon,
                          size: widget.size,
                          color: widget.color,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          items[index].name,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NameAndIcon {
  const _NameAndIcon(
    this.name,
    this.icon,
  );

  final String name;
  final String icon;
}
