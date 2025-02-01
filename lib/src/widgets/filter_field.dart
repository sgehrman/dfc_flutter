import 'package:dfc_flutter/l10n/app_localizations.dart';
import 'package:dfc_flutter/src/extensions/build_context_ext.dart';
import 'package:dfc_flutter/src/utils/debouncer.dart';
import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/buttons.dart';
import 'package:dfc_flutter/src/widgets/df_input_decoration.dart';
import 'package:flutter/material.dart';

class FilterField extends StatefulWidget {
  const FilterField({
    required this.controller,
    required this.onChange,
    this.onSubmit,
    this.onClose,
    this.autofocus = false,
    this.hint, // Search
    this.small = false,
    this.debounce = true,
  });

  final TextEditingController controller;
  final void Function(String) onChange;
  final void Function(String)? onSubmit;
  final void Function()? onClose;
  final bool autofocus;
  final bool small;
  final bool debounce;
  final String? hint;

  @override
  State<FilterField> createState() => _FilterFieldState();
}

class _FilterFieldState extends State<FilterField> {
  late DebounceLast<String> _debouncer;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _debouncer = DebounceLast<String>(
      milliseconds: 350,
      action: (value) {
        widget.onChange(value);
      },
    );

    _focusNode.addListener(focusListener);

    _setup();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListener);

    super.dispose();
  }

  void focusListener() {
    if (!_focusNode.hasFocus) {
      widget.onClose?.call();
    }
  }

  void debouncedOnChange(String text) {
    if (widget.debounce) {
      _debouncer.run(text);
    } else {
      _debouncer.action(text);
    }
  }

  void _setup() {
    widget.controller.addListener(() {
      if (widget.controller.text.isEmpty) {
        debouncedOnChange('');
      } else {
        debouncedOnChange(widget.controller.text.toLowerCase());
      }

      // for the x button to show and hide
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return TextField(
      style: TextStyle(
        fontSize: widget.small ? 16 : null,
      ),
      autofocus: widget.autofocus,
      controller: widget.controller,
      focusNode: _focusNode,
      onEditingComplete: () {
        if (widget.onSubmit != null) {
          widget.onSubmit?.call(widget.controller.text);

          // clear after submit, we don't want onChange to be called before submit
          widget.controller.text = '';
        }
      },
      decoration: inputDecoration(
        contentPadding: widget.small ? EdgeInsets.zero : null,
        hintText: widget.hint ?? l10n.search,
        prefixIconConstraints:
            widget.small ? DFIconButton.kIconConstraints : null,
        suffixIconConstraints:
            widget.small ? DFIconButton.kIconConstraints : null,
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 6),
          child: DFIconButton(
            color: context.primary,
            icon: const Icon(Icons.search),
            small: widget.small,
            onPressed: () {
              if (widget.onSubmit != null) {
                widget.onSubmit?.call(widget.controller.text);
              }
            },
          ),
        ),
        suffixIcon: Visibility(
          visible: Utils.isNotEmpty(widget.controller.text),
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            child: DFIconButton(
              small: widget.small,
              color: context.primary,
              icon: const Icon(Icons.close),
              onPressed: () {
                widget.controller.text = '';
                widget.onClose?.call();
              },
            ),
          ),
        ),
      ),
    );
  }
}
