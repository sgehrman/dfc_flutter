import 'package:dfc_flutter/src/svg_icons/community_svgs.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_bootstrap.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_community.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_fontawesome.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_material.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/search_field.dart';
import 'package:flutter/material.dart';

enum SVGSource {
  fontawesome,
  material,
  bootstrap,
  community,
}

class SvgScreen extends StatefulWidget {
  const SvgScreen({
    this.color = Colors.grey,
    this.size = 50,
    this.source = SVGSource.material,
  });

  final Color color;
  final double size;
  final SVGSource source;

  @override
  State<SvgScreen> createState() => _SvgScreenState();
}

class _SvgScreenState extends State<SvgScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    List<String> icons;
    List<String> iconNames;
    String title = 'Icon Library';

    switch (widget.source) {
      case SVGSource.material:
        title = 'Material Icon Library';
        icons = MaterialSvgs.everyIcon;
        iconNames = MaterialSvgs.iconNames;
        break;
      case SVGSource.bootstrap:
        title = 'Bootstrap Icon Library';
        icons = BootstrapSvgs.everyIcon;
        iconNames = BootstrapSvgs.iconNames;
        break;
      case SVGSource.fontawesome:
        title = 'Fontawesome Icon Library';
        icons = FontAwesomeSvgs.everyIcon;
        iconNames = FontAwesomeSvgs.iconNames;
        break;
      case SVGSource.community:
        title = 'Community Icon Library';
        icons = CommunitySvgs.everyIcon;
        iconNames = CommunitySvgs.iconNames;
        break;
    }

    final actions = [
      IconButton(
        onPressed: () {
          switch (widget.source) {
            case SVGSource.material:
              materialConvert();
              break;
            case SVGSource.bootstrap:
              bootStrapConvert();
              break;
            case SVGSource.fontawesome:
              fontawesomeConvert();
              break;
            case SVGSource.community:
              communityConvert();
              break;
          }
        },
        icon: const Icon(Icons.connected_tv_sharp),
      ),
    ];

    final gridItemWidth = widget.size * 3;
    final gridItemHeight = gridItemWidth;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Column(
        children: [
          SearchField(
            onChange: (value) {
              _filter = value.toLowerCase();
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
                    if (iconNames[i].toLowerCase().contains(_filter)) {
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
