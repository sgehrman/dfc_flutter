import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/google_fonts/google_fonts_widget.dart';

class GoogleFontsScreen extends StatelessWidget {
  final String appBarTitle = 'Choose a Font';
  final GlobalKey<GoogleFontsWidgetState> _widgetKey =
      GlobalKey<GoogleFontsWidgetState>();

  Widget useDefaultAction(BuildContext context) {
    return IconButton(
      tooltip: 'Use default font',
      onPressed: () {
        _widgetKey.currentState!.useDefault();
      },
      icon: const Icon(
        Icons.undo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = [
      useDefaultAction(context),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), actions: actions),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GoogleFontsWidget(
          key: _widgetKey,
        ),
      ),
    );
  }
}
