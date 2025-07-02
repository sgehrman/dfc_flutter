import 'package:dfc_flutter/dfc_flutter_web_lite.dart';
import 'package:flutter/material.dart';

class ResponsiveWidget extends StatefulWidget {
  const ResponsiveWidget({
    super.key,
    this.desktopScreen,
    this.tabletScreen,
    this.mobileScreen,
    this.desktopMinWidth = 950,
    this.tabletMinWidth = 600,
  });

  final Widget Function()? desktopScreen;
  final Widget Function()? tabletScreen;
  final Widget Function()? mobileScreen;
  final double desktopMinWidth;
  final double tabletMinWidth;

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  double screenWidth = 0;

  @override
  void didChangeDependencies() {
    screenWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget Function()? funct;

    if (screenWidth > widget.desktopMinWidth) {
      funct =
          widget.desktopScreen ?? widget.tabletScreen ?? widget.mobileScreen;
    } else if (screenWidth > widget.tabletMinWidth) {
      funct =
          widget.tabletScreen ?? widget.mobileScreen ?? widget.desktopScreen;
    }

    funct ??=
        widget.mobileScreen ?? widget.tabletScreen ?? widget.desktopScreen;

    if (funct != null) {
      return funct();
    }

    return const NothingWidget();
  }
}
