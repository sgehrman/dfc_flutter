import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPreloader extends StatefulWidget {
  const FontPreloader({
    required this.child,
    required this.fontName,
  });

  final Widget child;
  final String fontName;

  @override
  State<FontPreloader> createState() => _FontPreloaderState();
}

class _FontPreloaderState extends State<FontPreloader> {
  late Future<List<void>> _pendingFonts;

  @override
  void initState() {
    super.initState();

    _pendingFonts = GoogleFonts.pendingFonts([
      GoogleFonts.getTextTheme(widget.fontName),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pendingFonts,
      builder: (context, snapshot) {
        return Stack(
          children: [
            widget.child,
            if (snapshot.connectionState != ConnectionState.done)
              Positioned.fill(child: Container(color: context.surface)),
          ],
        );
      },
    );
  }
}