import 'package:flutter/material.dart';
import 'package:dfc_flutter/src/utils/utils.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    required this.onChange,
    required this.onSubmit,
    this.autofocus = false,
  });

  final void Function(String) onChange;
  final void Function(String) onSubmit;
  final bool autofocus;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      controller: _searchControllerConns,
      onEditingComplete: () {
        final result = _searchControllerConns.text;
        _searchControllerConns.text = '';

        widget.onSubmit(result);
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 2,
            color: Utils.isDarkMode(context) ? Colors.white24 : Colors.black12,
          ),
        ),
        labelText: 'Search',
        suffixIcon: IconButton(
          icon: Utils.isNotEmpty(_searchControllerConns.text)
              ? const Icon(Icons.close)
              : const Icon(Icons.search),
          onPressed: () {
            _searchControllerConns.text = '';
          },
        ),
      ),
    );
  }
}
