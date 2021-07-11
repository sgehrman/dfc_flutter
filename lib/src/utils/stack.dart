import 'dart:collection';

class ListStack<T> {
  final ListQueue<T> _list = ListQueue();

  /// check if the stack is empty.
  bool get isEmpty => _list.isEmpty;

  /// check if the stack is not empty.
  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;

  /// push element in top of the stack.
  void push(T e) {
    _list.addLast(e);
  }

  /// get the top of the stack and delete it.
  T? pop() {
    if (isEmpty) {
      return null;
    }

    final T res = _list.last;
    _list.removeLast();
    return res;
  }

  /// get the top of the stack without deleting it.
  T? top() {
    if (isEmpty) {
      return null;
    }

    return _list.last;
  }

  void clear() {
    _list.clear();
  }

  List<T> get list => _list.toList();
}
