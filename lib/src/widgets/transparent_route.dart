import 'package:flutter/material.dart';

class TransparentPageRoute<T> extends TransparentMaterialPageRoute<T> {
  TransparentPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // animation disabled
    return child;
  }
}

// SNG this was removed from extended_image, this is a replacement that probably doesn't work
// perfectly, fix later
class TransparentMaterialPageRoute<T> extends MaterialPageRoute<T> {
  TransparentMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            settings: settings,
            builder: builder,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }
}
