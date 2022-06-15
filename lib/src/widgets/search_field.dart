import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    required this.onChange,
    required this.onSubmit,
    this.autofocus = false,
    this.label = 'Search',
    this.hint = 'Search',
    this.filled = false,
  });

  final void Function(String) onChange;
  final void Function(String) onSubmit;
  final bool autofocus;
  final bool filled;
  final String label;
  final String hint;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _searchControllerConns;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _focusNode!.addListener(_listener);
    _focusNode!.skipTraversal = true;

    _searchControllerConns = TextEditingController();

    _setup();
  }

  void _listener() {
    // this focus node was added to prevent auto focus when the window is refocused
    // The keyboard comes up and is annoying even when the tab for this is off screen
    if (!_focusNode!.hasFocus) {
      _focusNode!.removeListener(_listener);
      _focusNode = null;

      _focusNode = FocusNode();
      _focusNode!.addListener(_listener);
      _focusNode!.skipTraversal = true;

      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchControllerConns.dispose();
    _focusNode!.removeListener(_listener);

    super.dispose();
  }

  void _setup() {
    _searchControllerConns.addListener(() {
      if (_searchControllerConns.text.isEmpty) {
        widget.onChange('');
      } else {
        widget.onChange(_searchControllerConns.text.toLowerCase());
      }

      // for the x button to show and hide
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var filled = true;
    Color? fillColor = Colors.white;
    EdgeInsets? contentPadding = const EdgeInsets.only(
      left: 30,
    );

    var focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
    );

    var enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
    );

    if (!widget.filled) {
      filled = false;
      fillColor = null;
      contentPadding = null;

      focusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 2,
          color: Theme.of(context).primaryColorLight,
        ),
      );

      enabledBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 2,
          color: Utils.isDarkMode(context) ? Colors.white24 : Colors.black12,
        ),
      );
    }

    return TextField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      controller: _searchControllerConns,
      onEditingComplete: () {
        widget.onSubmit(_searchControllerConns.text);

        // clear after submit, we don't want onChange to be called before submit
        _searchControllerConns.text = '';
      },
      style: TextStyle(
        color: widget.filled
            ? Colors.black
            : Utils.isDarkMode(context)
                ? Colors.white
                : Colors.black,
      ),
      decoration: InputDecoration(
        filled: filled,
        fillColor: fillColor,
        contentPadding: contentPadding,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: widget.filled
              ? Colors.black
              : Utils.isDarkMode(context)
                  ? Colors.white
                  : Colors.black,
        ),
        labelText: widget.label,
        prefixIcon: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          color: Theme.of(context).primaryColor,
          constraints: const BoxConstraints(maxHeight: 32, maxWidth: 32),
          icon: const Icon(Icons.search),
          onPressed: () {
            widget.onSubmit(_searchControllerConns.text);
          },
        ),
        suffixIcon: Visibility(
          visible: Utils.isNotEmpty(_searchControllerConns.text),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchControllerConns.text = '';
              },
            ),
          ),
        ),
      ),
    );
  }
}
