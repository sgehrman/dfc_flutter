import 'package:dfc_flutter/src/utils/utils.dart';
import 'package:dfc_flutter/src/widgets/form_builder/field_builder.dart';
import 'package:dfc_flutter/src/widgets/form_builder/form_params.dart';
import 'package:dfc_flutter/src/widgets/json_viewer_screen.dart';
import 'package:flutter/material.dart';

class FormBuilder extends StatefulWidget {
  const FormBuilder({
    required this.params,
    required this.onSubmit,
    this.outlinedBorders = false,
  });

  final FormBuilderParams params;
  final bool outlinedBorders;
  final bool Function(FormBuilderParams params) onSubmit;

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();

    widget.params.addListener(paramsListener);

    widget.params.saveNotifier?.addListener(saveListener);
  }

  @override
  void dispose() {
    widget.params.removeListener(paramsListener);
    widget.params.saveNotifier?.removeListener(saveListener);

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FormBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.params.removeListener(paramsListener);
    widget.params.addListener(paramsListener);
  }

  void saveListener() {
    _save();
  }

  void paramsListener() {
    setState(() {});
  }

  bool _validateAndSave() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        return true;
      }
    }

    return false;
  }

  void _save() {
    if (_validateAndSave()) {
      final success = widget.onSubmit(widget.params);
      if (success) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  List<Widget> _saveButtons() {
    // don't show the buttons if we have a save notifier
    if (widget.params.saveNotifier == null) {
      return [
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        //   style: ElevatedButton.styleFrom(
        //     primary: Theme.of(context).accentColor,
        //   ),
        //   child: const Text('Cancel'),
        // ),
        TextButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ];
    }

    return [];
  }

  Widget _jsonButton() {
    const bool disabled = true;

    if (disabled) {
      return const NothingWidget();
    }

    // ignore: dead_code
    return TextButton(
      onPressed: () {
        if (_validateAndSave()) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) {
                return JsonViewerScreen(
                  map: widget.params.map,
                  title: 'Form Data',
                );
              },
            ),
          );
        }
      },
      child: const Text('Json'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...FieldBuilder.fields(
            context: context,
            outlinedBorders: widget.outlinedBorders,
            autovalidate: _autovalidate,
            builderParams: widget.params,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 10,
              children: [
                _jsonButton(),
                ..._saveButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
