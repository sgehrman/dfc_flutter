import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/widgets/bottom_navbar/bottom_navbar_painter.dart';
import 'package:dfc_flutter/src/widgets/bottom_navbar/tab_item.dart';

const double circleSize = 60;
const double arcHeight = 70;
const double arcWidth = 90;
const double circleOutline = 10;
const double shadowAllowance = 20;

class BottomNavBarController {
  BottomNavBarState? barState;

  void setPage(int index) {
    if (barState != null) {
      barState!.setPage(index);
    }
  }
}

class BottomNavBar extends StatefulWidget {
  BottomNavBar(
      {required this.tabs,
      required this.onTabChangedListener,
      this.controller,
      this.initialSelection = 0,
      this.circleColor,
      this.activeIconColor,
      this.inactiveIconColor,
      this.textColor,
      this.gradient,
      this.barBackgroundColor,
      this.barHeight = 60})
      : assert(tabs.isNotEmpty && tabs.length < 5);

  final BottomNavBarController? controller;
  final Function(int position) onTabChangedListener;
  final Color? circleColor;
  final Color? activeIconColor;
  final Color? inactiveIconColor;
  final Color? textColor;
  final Gradient? gradient;
  final Color? barBackgroundColor;
  final double barHeight;
  final List<TabData> tabs;
  final int initialSelection;

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData activeIcon = Icons.search;

  int currentSelected = 0;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color? circleColor;
  Color? activeIconColor;
  Color? inactiveIconColor;
  Color? barBackgroundColor;
  Color? textColor;
  Gradient? gradient;
  late Color shadowColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon = widget.tabs[currentSelected].iconData;

    circleColor = (widget.circleColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? const Color(0xFF212121)
            : Colors.white
        : widget.barBackgroundColor;
    textColor = (widget.textColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;
    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;
    gradient = widget.gradient;
    shadowColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;
  }

  @override
  void initState() {
    super.initState();
    widget.controller!.barState = this;

    _setSelected(widget.tabs[widget.initialSelection].key);
  }

  @override
  void dispose() {
    widget.controller!.barState = null;
    super.dispose();
  }

  void _setSelected(UniqueKey key) {
    final int selected =
        widget.tabs.indexWhere((tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].iconData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: widget.barHeight,
          decoration: BoxDecoration(color: barBackgroundColor, boxShadow: [
            BoxShadow(
                color: shadowColor, offset: const Offset(0, -1), blurRadius: 8)
          ]),
          child: Row(
            children: widget.tabs
                .map(
                  (t) => TabItem(
                    uniqueKey: t.key,
                    selected: t.key == widget.tabs[currentSelected].key,
                    iconData: t.iconData,
                    title: t.title,
                    iconColor: inactiveIconColor,
                    gradient: gradient,
                    textColor: textColor,
                    callbackFunction: (uniqueKey) {
                      final int selected = widget.tabs
                          .indexWhere((tabData) => tabData.key == uniqueKey);

                      widget.onTabChangedListener(selected);
                      _setSelected(uniqueKey);
                      _initAnimationAndStart(_circleAlignX, 1);
                    },
                  ),
                )
                .toList(),
          ),
        ),
        Positioned.fill(
          top: -(circleSize + circleOutline + shadowAllowance) / 2,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: animDuration),
            curve: Curves.easeOut,
            alignment: Alignment(_circleAlignX, 1),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: FractionallySizedBox(
                widthFactor: 1 / widget.tabs.length,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: circleSize + circleOutline + shadowAllowance,
                      width: circleSize + circleOutline + shadowAllowance,
                      child: ClipRect(
                        clipper: HalfClipper(),
                        child: Center(
                          child: Container(
                            width: circleSize + circleOutline,
                            height: circleSize + circleOutline,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: shadowColor, blurRadius: 8)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: arcHeight,
                        width: arcWidth,
                        child: CustomPaint(
                          painter: HalfPainter(barBackgroundColor!),
                        )),
                    SizedBox(
                      height: circleSize - 5,
                      width: circleSize - 5,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradient,
                            color: circleColor),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: AnimatedOpacity(
                            duration:
                                const Duration(milliseconds: animDuration ~/ 5),
                            opacity: _circleIconAlpha,
                            child: Icon(
                              activeIcon,
                              color: activeIconColor,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(const Duration(milliseconds: animDuration ~/ 5), () {
      setState(() {
        activeIcon = nextIcon;
      });
    }).then((_) {
      Future.delayed(const Duration(milliseconds: animDuration ~/ 5 * 3), () {
        setState(() {
          _circleIconAlpha = 1;
        });
      });
    });
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() {
      currentSelected = page;
    });
  }
}

class TabData {
  TabData({required this.iconData, required this.title});

  IconData iconData;
  String title;
  final UniqueKey key = UniqueKey();
}
