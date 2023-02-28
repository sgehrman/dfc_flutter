import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/text_with_links.dart';
import 'package:flutter/material.dart';

const double arrowIconSize = 26;

class JsonViewerWidget extends StatefulWidget {
  const JsonViewerWidget(this.jsonObj, {this.notRoot});

  final Map<String, dynamic> jsonObj;
  final bool? notRoot;

  @override
  JsonViewerWidgetState createState() => JsonViewerWidgetState();
}

String _intToString(int content) {
  String contentStr = content.toString();

  // convert to date if number is large
  // chargebee is seconds, so we check for that too
  DateTime? date;
  if (content > 1000000000000) {
    date = DateTime.fromMillisecondsSinceEpoch(content);
  } else if (content > 1000000000) {
    date = DateTime.fromMillisecondsSinceEpoch(content * 1000);
  }

  if (date != null && date.year > 1700 && date.year < 3000) {
    contentStr = date.toString();
  }

  return contentStr;
}

class JsonViewerWidgetState extends State<JsonViewerWidget> {
  final Set<String> _closedFlag = {};

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot ?? false) {
      return Container(
        padding: const EdgeInsets.only(left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );
  }

  Widget _ex(bool ex, MapEntry<String, dynamic> entry) {
    if (ex) {
      final icon = !_closedFlag.contains(entry.key)
          ? const Icon(
              Icons.arrow_drop_down,
              size: arrowIconSize,
            )
          : const Icon(
              Icons.arrow_right,
              size: arrowIconSize,
            );

      return InkWell(
        onTap: () {
          setState(() {
            _toggleOpen(entry.key);
          });
        },
        child: icon,
      );
    } else {
      return const Icon(
        Icons.arrow_right,
        color: Colors.transparent,
        size: arrowIconSize,
      );
    }
  }

  Widget _exAndInk(bool ex, bool ink, MapEntry<dynamic, dynamic> entry) {
    if (ex && ink) {
      return InkWell(
        onTap: () {
          setState(() {
            _toggleOpen(entry.key as String);
          });
        },
        child: Text(
          entry.key as String,
          style: TextStyle(
            color: Utils.isDarkMode(context) ? Colors.white : Colors.black,
          ),
        ),
      );
    } else {
      return Text(
        entry.key as String,
        style: TextStyle(
          color: Utils.isDarkMode(context) ? Colors.white : Colors.black,
        ),
      );
    }
  }

  List<Widget> _getList() {
    final List<Widget> list = [];

    for (final entry in widget.jsonObj.entries) {
      final bool ex = isExtensible(entry.value);
      final bool ink = isInkWell(entry.value);
      list.add(
        Row(
          children: <Widget>[
            _ex(ex, entry),
            _exAndInk(ex, ink, entry),
            const Text(
              ':',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 3),
            getValueWidget(entry),
          ],
        ),
      );
      list.add(const SizedBox(height: 4));
      if (!_closedFlag.contains(entry.key)) {
        if (entry.value is List || entry.value is Map) {
          list.add(getContentWidget(entry.value));
        }
      }
    }

    return list;
  }

  static Widget getContentWidget(dynamic content) {
    if (content is List) {
      return JsonArrayViewerWidget(content, notRoot: true);
    } else {
      return JsonViewerWidget(
        Map<String, dynamic>.from(content as Map),
        notRoot: true,
      );
    }
  }

  static bool isInkWell(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if (content is DateTime) {
      return false;
    } else if (content is List) {
      return true;
    }

    return true;
  }

  Widget getValueWidget(MapEntry<dynamic, dynamic> entry) {
    if (entry.value == null) {
      return const Expanded(
        child: Text(
          'undefined',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is int) {
      return Expanded(
        child: Text(
          _intToString(entry.value as int),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is String) {
      return Expanded(
        child: TextWithLinks(
          entry.value as String,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    } else if (entry.value is bool) {
      return Expanded(
        child: Text(
          entry.value.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is DateTime) {
      return Expanded(
        child: Text(
          entry.value.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is double) {
      return Expanded(
        child: Text(
          entry.value.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (entry.value is List) {
      final List<dynamic> list = entry.value as List;

      if (list.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              _toggleOpen(entry.key as String);
            });
          },
          child: Text(
            'Array<${getTypeName(list.first)}>[${list.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          _toggleOpen(entry.key as String);
        });
      },
      child: const Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  static bool isExtensible(dynamic content) {
    if (content == null) {
      return false;
    } else if (content is int) {
      return false;
    } else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is DateTime) {
      return false;
    } else if (content is double) {
      return false;
    }

    return true;
  }

  static String getTypeName(dynamic content) {
    if (content is int) {
      return 'int';
    } else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if (content is List) {
      return 'List';
    } else if (content is DateTime) {
      return 'DateTime';
    }

    return 'Object';
  }

  void _toggleOpen(String index) {
    if (_closedFlag.contains(index)) {
      _closedFlag.remove(index);
    } else {
      _closedFlag.add(index);
    }
  }
}

class JsonArrayViewerWidget extends StatefulWidget {
  const JsonArrayViewerWidget(this.jsonArray, {this.notRoot});

  final List<dynamic> jsonArray;

  final bool? notRoot;

  @override
  State<JsonArrayViewerWidget> createState() => _JsonArrayViewerWidgetState();
}

class _JsonArrayViewerWidgetState extends State<JsonArrayViewerWidget> {
  final Set<int> _closedFlag = {};

  @override
  Widget build(BuildContext context) {
    if (widget.notRoot ?? false) {
      return Container(
        padding: const EdgeInsets.only(left: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList(),
    );
  }

  Widget _ex(bool ex, int i) {
    if (ex) {
      final icon = !_closedFlag.contains(i)
          ? const Icon(
              Icons.arrow_drop_down,
              size: arrowIconSize,
            )
          : const Icon(
              Icons.arrow_right,
              size: arrowIconSize,
            );

      return InkWell(
        onTap: () {
          setState(() {
            _toggleOpen(i);
          });
        },
        child: icon,
      );
    } else {
      return const Icon(
        Icons.arrow_right,
        color: Colors.transparent,
        size: arrowIconSize,
      );
    }
  }

  Widget _exAndInk(bool ex, bool ink, int i, dynamic content) {
    if (ex && ink) {
      return getInkWell(i);
    }

    return Text(
      '[$i]',
      style: TextStyle(
        color: content == null
            ? Colors.grey
            : Utils.isDarkMode(context)
                ? Colors.white
                : Colors.black,
      ),
    );
  }

  List<Widget> _getList() {
    final List<Widget> list = [];
    int i = 0;
    for (final content in widget.jsonArray) {
      final bool ex = JsonViewerWidgetState.isExtensible(content);
      final bool ink = JsonViewerWidgetState.isInkWell(content);
      list.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ex(ex, i),
            _exAndInk(ex, ink, i, content),
            const Text(
              ':',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(width: 3),
            getValueWidget(content, i),
          ],
        ),
      );
      list.add(const SizedBox(height: 4));
      if (!_closedFlag.contains(i)) {
        if (content is List || content is Map) {
          list.add(JsonViewerWidgetState.getContentWidget(content));
        }
      }
      i++;
    }

    return list;
  }

  void _toggleOpen(int index) {
    if (_closedFlag.contains(index)) {
      _closedFlag.remove(index);
    } else {
      _closedFlag.add(index);
    }
  }

  InkWell getInkWell(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _toggleOpen(index);
        });
      },
      child: Text(
        '[$index]',
        style: TextStyle(
          color: Utils.isDarkMode(context) ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget getValueWidget(dynamic content, int index) {
    if (content == null) {
      return const Expanded(
        child: Text(
          'undefined',
          style: TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is int) {
      return Expanded(
        child: Text(
          _intToString(content),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is String) {
      return Expanded(
        child: TextWithLinks(
          content,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    } else if (content is bool) {
      return Expanded(
        child: Text(
          content.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is double) {
      return Expanded(
        child: Text(
          content.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
      );
    } else if (content is List) {
      if (content.isEmpty) {
        return const Text(
          'Array[0]',
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return InkWell(
          onTap: () {
            setState(() {
              _toggleOpen(index);
            });
          },
          child: Text(
            'Array<${JsonViewerWidgetState.getTypeName(content)}>[${content.length}]',
            style: const TextStyle(color: Colors.grey),
          ),
        );
      }
    }

    return InkWell(
      onTap: () {
        setState(() {
          _toggleOpen(index);
        });
      },
      child: const Text(
        'Object',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
