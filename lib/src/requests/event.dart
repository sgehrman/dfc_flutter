import 'dart:async';

class Event {
  Event() {
    _streamController = StreamController<dynamic>.broadcast(sync: true);
  }

  StreamController<dynamic>? _streamController;

  Stream<dynamic>? _getStream() {
    return _streamController?.stream;
  }

  void dispose() {
    if (_streamController != null) {
      _streamController!.close();
      _streamController = null;
    }
  }

  void listen(void Function(dynamic event) callback) {
    final Stream<dynamic> stream = _getStream()!;
    stream.listen(callback);
  }

  void publish(dynamic event) {
    if (_streamController != null) {
      _streamController!.add(event);
    }
  }
}
