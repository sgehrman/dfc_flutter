import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class SvgImage extends StatefulWidget {
  const SvgImage(this.url);

  final String url;

  @override
  _SvgImageState createState() => _SvgImageState();
}

class _SvgImageState extends State<SvgImage> {
  String? svgString;
  bool failed = false;

  @override
  void initState() {
    super.initState();

    _fetchImage();
  }

  Future<void> _fetchImage() async {
    try {
      final http.Response response =
          await http.get(Uri.dataFromString(widget.url));

      if (mounted) {
        setState(() {
          svgString = response.body;
        });
      }
    } catch (error) {
      print(error);

      failed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (svgString != null) {
      return SvgPicture.string(
        svgString!,
        semanticsLabel: svgString,
        placeholderBuilder: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
      );
    }

    if (failed) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Failed to load SVG image.'),
      ));
    }

    return const Center(child: CircularProgressIndicator());
  }
}
