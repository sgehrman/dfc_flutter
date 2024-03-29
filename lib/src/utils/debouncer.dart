import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.milliseconds = 500}) {
    _duration = Duration(milliseconds: milliseconds);
  }

  final int milliseconds;
  Timer? _timer;
  bool _disposed = false;
  late Duration _duration;

  void dispose() {
    _disposed = true;
  }

  void _debugLog(String message) {
    const debug = false;

    // ignore: dead_code
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
        _duration,
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
        _timer = Timer(
          _duration,
          () {
            _timer!.cancel();
            _timer = null;

            _debugLog('## debouncer done');
          },
        );

        _debugLog('## debouncer running');
        action();
      }
    }
  }

  void runAndAwait(Future<void> Function() action) {
    if (_timer != null) {
      _debugLog('## debouncer already running');
    } else {
      _debugLog('## debouncer running');

      _timer = Timer(
        _duration,
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

// =================================================================

class DebounceLast<T> {
  DebounceLast({
    required this.action,
    this.milliseconds = 500,
  });

  final int milliseconds;
  final Function(T value) action;
  Timer? _timer;
  bool _disposed = false;
  T? _last;

  void dispose() {
    _disposed = true;
  }

  void run(T data) {
    _last = data;

    if (_timer != null) {
      // print('## Debooster already running');
    } else {
      _timer = Timer(
        Duration(milliseconds: milliseconds),
        () {
          _timer!.cancel();
          _timer = null;

          if (!_disposed) {
            if (_last != null) {
              action(_last as T);
            }

            _last = null;
          }
        },
      );
    }
  }
}
