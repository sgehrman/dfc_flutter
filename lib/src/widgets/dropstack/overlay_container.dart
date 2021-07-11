import 'package:flutter/material.dart';

class OverlayContainer extends StatefulWidget {
  const OverlayContainer({
    required this.child,
  });

  final Widget child;

  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _show();
  }

  @override
  void didUpdateWidget(OverlayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _show();
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  void _show() {
    // overlay insert calls setState, can't call during build
    Future.delayed(const Duration(milliseconds: 1), () {
      _hide();

      _overlayEntry = OverlayEntry(builder: (context) {
        return widget.child;
      });

      Overlay.of(context)!.insert(_overlayEntry!);
    });
  }

  void _hide() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
