import 'package:flutter/material.dart';

// Kind of a hack.  We need a context in some situations for code that runs
// in the background or utility code
class SharedContext {
  factory SharedContext() {
    return _instance ??= SharedContext._();
  }
  SharedContext._();

  static SharedContext? _instance;
  late BuildContext? _mainContext;
  late BuildContext? _scaffoldContext;

  BuildContext get mainContext {
    // Will crash if null, this should never be null
    return _mainContext!;
  }

  set mainContext(BuildContext context) {
    _mainContext = context;
  }

  // use this if you need a dialog or toast
  BuildContext get scaffoldContext {
    // Will crash if null, this should never be null
    return _scaffoldContext!;
  }

  set scaffoldContext(BuildContext context) {
    _scaffoldContext = context;
  }
}

// =======================================================================
// =======================================================================

class SharedMainContext extends StatelessWidget {
  const SharedMainContext({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    SharedContext().mainContext = context;
    return child;
  }
}

// =======================================================================
// =======================================================================

class SharedScaffoldContext extends StatelessWidget {
  const SharedScaffoldContext({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    SharedContext().scaffoldContext = context;
    return child;
  }
}
