import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//  based off of flutter_datetime_formfield: ^0.1.2

class DateTimeFormField extends StatelessWidget {
  DateTimeFormField({
    required DateTime? initialValue,
    required String? label,
    DateFormat? formatter,
    this.onSaved,
    this.validator,
    this.autovalidate = false,
    this.enabled = true,
    this.onlyDate = false,
    this.onlyTime = false,
    DateTime? firstDate,
    DateTime? lastDate,
  })  : assert(!onlyDate || !onlyTime),
        initialValue = initialValue ?? DateTime.now(),
        label = label ?? 'Date Time',
        formatter = formatter ??
            (onlyDate
                ? DateFormat('EEE, MMM d, yyyy')
                : (onlyTime
                    ? DateFormat('h:mm a')
                    : DateFormat('EE, MMM d, yyyy h:mm a'))),
        firstDate = firstDate ?? DateTime(1970),
        lastDate = lastDate ?? DateTime(2100);

  final DateTime initialValue;
  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<DateTime>? validator;
  final bool autovalidate;
  final bool enabled;
  final String label;
  final DateFormat formatter;
  final bool onlyDate;
  final bool onlyTime;
  final DateTime firstDate;
  final DateTime lastDate;

  Future<void> _tap(
      BuildContext context, FormFieldState<DateTime> state) async {
    DateTime? date;
    TimeOfDay? time = const TimeOfDay(hour: 0, minute: 0);
    if (onlyDate) {
      if (Platform.isAndroid) {
        date = await showDatePicker(
          context: context,
          initialDate: state.value!,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (date != null) {
          state.didChange(date);
        }
      } else {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime dateTime) =>
                    state.didChange(dateTime),
                initialDateTime: state.value,
                minimumYear: firstDate.year,
                maximumYear: lastDate.year,
              ),
            );
          },
        );
      }
    } else if (onlyTime) {
      if (Platform.isAndroid) {
        time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(state.value!),
        );
        if (time != null) {
          state.didChange(DateTime(
            initialValue.year,
            initialValue.month,
            initialValue.day,
            time.hour,
            time.minute,
          ));
        }
      } else {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime dateTime) =>
                    state.didChange(dateTime),
                initialDateTime: state.value,
                minuteInterval: 5,
              ),
            );
          },
        );
      }
    } else {
      if (Platform.isAndroid) {
        date = await showDatePicker(
          context: context,
          initialDate: state.value!,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (date != null) {
          time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(state.value!),
          );
          if (time != null) {
            state.didChange(DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            ));
          }
        }
      } else {
        await showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext builder) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CupertinoDatePicker(
                onDateTimeChanged: (DateTime dateTime) =>
                    state.didChange(dateTime),
                initialDateTime: state.value,
                minuteInterval: 5,
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      autovalidateMode:
          autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
      initialValue: initialValue,
      onSaved: onSaved,
      enabled: enabled,
      builder: (FormFieldState<DateTime> state) {
        return InkWell(
          onTap: () {
            if (enabled) {
              _tap(context, state);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              icon: const Icon(Icons.date_range),
              labelText: label,
              errorText: state.errorText,
            ),
            child: Text(formatter.format(state.value!)),
          ),
        );
      },
    );
  }
}
