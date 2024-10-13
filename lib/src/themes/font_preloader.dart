import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPreloader extends StatefulWidget {
  const FontPreloader({
    required this.child,
    required this.backgroundColor,
  });

  final Widget child;
  final Color backgroundColor;

  @override
  State<FontPreloader> createState() => _FontPreloaderState();
}

class _FontPreloaderState extends State<FontPreloader> {
  late Future<List<void>> _pendingFonts;

  @override
  void initState() {
    super.initState();

    _pendingFonts = GoogleFonts.pendingFonts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pendingFonts,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(color: widget.backgroundColor);
        }

        return widget.child;
      },
    );
  }
}
