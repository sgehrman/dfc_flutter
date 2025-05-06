import 'package:dfc_flutter/src/hive_db/hive_utils.dart';
import 'package:dfc_flutter/src/utils/debouncer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class PreferencesListener extends StatefulWidget {
  const PreferencesListener({
    required this.builder,
    required this.keys,
    this.debounceMilliseconds = 300,
  });

  final Widget Function(BuildContext context) builder;
  final int debounceMilliseconds;
  final List<String> keys;

  @override
  State<PreferencesListener> createState() => _PreferencesListenerState();
}

class _PreferencesListenerState extends State<PreferencesListener> {
  late ValueListenable<Box<dynamic>> _listenable;
  late Debouncer _updater;

  @override
  void initState() {
    super.initState();

    _updater = Debouncer(milliseconds: widget.debounceMilliseconds);

    _listenable = PrefsBox().box.listenable(
          keys: widget.keys.isEmpty ? null : widget.keys,
        )!;

    _listenable.addListener(listener);
  }

  @override
  void dispose() {
    _listenable.removeListener(listener);

    super.dispose();
  }

  void listener() {
    _updater.runImmediate(
      () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.debounceMilliseconds > 0) {
      return widget.builder(context);
    }

    return ValueListenableBuilder<Box<dynamic>>(
      valueListenable: PrefsBox().box.listenable(
            keys: widget.keys.isEmpty ? null : widget.keys,
          )!,
      builder: (context, prefsBox, _) {
        return widget.builder(context);
      },
    );
  }
}
