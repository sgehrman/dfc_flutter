import 'package:dfc_flutter/src/svg_icons/svg_converter_bootstrap.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_community.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_fontawesome.dart';
import 'package:dfc_flutter/src/svg_icons/svg_converter_material.dart';
import 'package:dfc_flutter/src/svg_icons/svg_icon.dart';
import 'package:dfc_flutter/src/utils/debouncer.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<_NameAndIcon> _items = [];
  List<String> _icons = [];
  String _title = 'Icon Library';
  final _updater = Debouncer(milliseconds: 200);

  void _updateItems() {
    List<String> iconNames;

    switch (widget.source) {
      case SVGSource.material:
        _title = 'Material Icon Library';
        _icons = MaterialSvgs.everyIcon;
        iconNames = MaterialSvgs.iconNames;
        break;
      case SVGSource.bootstrap:
        _title = 'Bootstrap Icon Library';
        _icons = BootstrapSvgs.everyIcon;
        iconNames = BootstrapSvgs.iconNames;
        break;
      case SVGSource.fontawesome:
        _title = 'Fontawesome Icon Library';
        _icons = FontAwesomeSvgs.everyIcon;
        iconNames = FontAwesomeSvgs.iconNames;
        break;
      case SVGSource.community:
        _title = 'Community Icon Library';
        _icons = CommunitySvgs.everyIcon;
        iconNames = CommunitySvgs.iconNames;
        break;
    }

    final List<_NameAndIcon> items = [];

    for (int i = 0; i < iconNames.length; i++) {
      if (Utils.isNotEmpty(_filter)) {
        if (iconNames[i].toLowerCase().contains(_filter)) {
          items.add(_NameAndIcon(iconNames[i], _icons[i]));
        }
      } else {
        items.add(_NameAndIcon(iconNames[i], _icons[i]));
      }
    }

    _items = items;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _updateItems();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(_title),
        actions: actions,
      ),
      body: Column(
        children: [
          SearchField(
            onChange: (value) {
              _filter = value.toLowerCase();
              _updater.run(_updateItems);
            },
            onSubmit: (value) {},
            hint: 'Filter',
            label: '',
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth ~/ gridItemWidth,
                    mainAxisExtent: gridItemHeight,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: item.name));

                            Utils.showCopiedToast(context);
                          },
                          child: SvgIcon(
                            item.icon,
                            size: widget.size,
                            color: widget.color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.name,
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
