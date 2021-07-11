import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.milliseconds = 500});

  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;
  bool _disposed = false;

  void dispose() {
    _disposed = true;
  }

  void _debugLog(String message) {
    const debug = false;

    if (debug) {
      print(message);
    }
  }

  void run(VoidCallback action) {
    if (_timer != null) {
      _debugLog('## debouncer already running');
    } else {
      _debugLog('## debouncer running');

      _timer = Timer(
        Duration(milliseconds: milliseconds),
        () {
          _timer!.cancel();
          _timer = null;

          if (!_disposed) {
            action();

            _debugLog('## debouncer done');
          }
        },
      );
    }
  }

  void runImmediate(VoidCallback action) {
    if (_timer != null) {
      _debugLog('## debouncer already running');
    } else {
      if (!_disposed) {
        _debugLog('## debouncer running');

        action();

        _timer = Timer(
          Duration(milliseconds: milliseconds),
          () {
            _timer!.cancel();
            _timer = null;

            _debugLog('## debouncer done');
          },
        );
      }
    }
  }

  void runAndAwait(Future<void> Function() action) {
    if (_timer != null) {
      _debugLog('## debouncer already running');
    } else {
      _debugLog('## debouncer running');

      _timer = Timer(
        Duration(milliseconds: milliseconds),
        () async {
          if (!_disposed) {
            try {
              await action();
            } catch (err) {
              print(err);
            }

            _debugLog('## debouncer done');
          } else {
            _debugLog('## debouncer already disposed');
          }

          _timer!.cancel();
          _timer = null;
        },
      );
    }
  }
}
