import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    required this.startDate,
    required this.initialSelectedDate,
    this.selectableDayPredicate,
    super.key,
    this.width = 60,
    this.height = 100,
    this.controller,
    this.selectionColor = _DateColors.defaultSelectionColor,
    this.daysCount = 60,
    this.onDateChange,
    this.locale = 'en_US',
  });

  final DateTime startDate;
  final DateTime initialSelectedDate;
  final SelectableDayPredicate? selectableDayPredicate;

  final double width;
  final double height;
  final DatePickerController? controller;
  final Color selectionColor;
  final DateChangeListener? onDateChange;
  final int daysCount;
  final String locale;

  @override
  State<DatePicker> createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime? _currentDate;

  final ScrollController _controller = ScrollController();

  TextStyle? selectedDateStyle;
  TextStyle? selectedMonthStyle;
  TextStyle? selectedDayStyle;

  @override
  void initState() {
    // Init the calendar locale
    initializeDateFormatting(widget.locale);
    // Set initial Values
    _currentDate = widget.initialSelectedDate;

    if (widget.controller != null) {
      widget.controller!.datePickerState = this;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          final tmpDate = widget.startDate.add(Duration(days: index));
          final date = DateTime(tmpDate.year, tmpDate.month, tmpDate.day);

          final isSelected = date == _currentDate;

          var disabled = false;
          if (widget.selectableDayPredicate != null) {
            disabled = !widget.selectableDayPredicate!(date);
          }

          return _DateWidget(
            disabled: disabled,
            date: date,
            width: widget.width,
            locale: widget.locale,
            selectionColor: widget.selectionColor,
            isSelected: isSelected,
            onDateSelected: (selectedDate) {
              widget.onDateChange?.call(selectedDate);
              setState(() {
                _currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }
}

class DatePickerController {
  DatePickerState? _datePickerState;

  set datePickerState(DatePickerState state) {
    _datePickerState = state;
  }

  DateTime? get currentDate {
    assert(
      _datePickerState != null,
      'DatePickerController is not attached to any DatePicker View.',
    );

    return _datePickerState!._currentDate;
  }

  void jumpToSelection() {
    assert(
      _datePickerState != null,
      'DatePickerController is not attached to any DatePicker View.',
    );

    _datePickerState!._controller.jumpTo(_calculateDateOffset(currentDate!));
  }

  void animateToSelection({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
  }) {
    assert(
      _datePickerState != null,
      'DatePickerController is not attached to any DatePicker View.',
    );

    _datePickerState!._controller.animateTo(
      _calculateDateOffset(currentDate!),
      duration: duration,
      curve: curve,
    );
  }

  void animateToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
  }) {
    assert(
      _datePickerState != null,
      'DatePickerController is not attached to any DatePicker View.',
    );

    _datePickerState!._controller.animateTo(
      _calculateDateOffset(date),
      duration: duration,
      curve: curve,
    );
  }

  double _calculateDateOffset(DateTime date) {
    final offset =
        date.difference(_datePickerState!.widget.startDate).inDays + 1;

    return (offset * _datePickerState!.widget.width) + (offset * 6);
  }
}

class _DateWidget extends StatelessWidget {
  const _DateWidget({
    required this.date,
    required this.isSelected,
    this.disabled,
    this.width,
    this.onDateSelected,
    this.locale,
    this.selectionColor,
  });

  final double? width;
  final bool? disabled;
  final DateTime date;
  final bool isSelected;
  final DateSelectionCallback? onDateSelected;
  final String? locale;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled!
          ? null
          : () {
              onDateSelected?.call(date);
            },
      child: Container(
        width: width,
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: isSelected ? selectionColor : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateFormat('MMM', locale).format(date).toUpperCase(),
                style: defaultMonthTextStyle(
                  disabled: disabled!,
                  isSelected: isSelected,
                ),
              ),
              Text(
                date.day.toString(),
                style: defaultDateTextStyle(
                  disabled: disabled!,
                  isSelected: isSelected,
                ),
              ),
              Text(
                DateFormat('E', locale).format(date).toUpperCase(),
                style: defaultDayTextStyle(
                  disabled: disabled!,
                  isSelected: isSelected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateColors {
  _DateColors._();

  // static const Color defaultDateColor = Colors.black;
  // static const Color defaultDayColor = Colors.black;
  static const Color defaultMonthColor = Colors.black;
  static const Color disabledColor = Colors.grey;
  static const Color selectedTextColor = Colors.white;
  static const Color defaultSelectionColor = Color(0x30000000);
}

TextStyle defaultMonthTextStyle({
  bool disabled = false,
  bool isSelected = false,
}) {
  var color = _DateColors.defaultMonthColor;
  if (disabled) {
    color = _DateColors.disabledColor;
  } else if (isSelected) {
    color = _DateColors.selectedTextColor;
  }

  return TextStyle(
    color: color,
    fontSize: Dimen.monthTextSize,
    fontWeight: FontWeight.w500,
  );
}

TextStyle defaultDateTextStyle({
  bool disabled = false,
  bool isSelected = false,
}) {
  var color = _DateColors.defaultMonthColor;
  if (disabled) {
    color = _DateColors.disabledColor;
  } else if (isSelected) {
    color = _DateColors.selectedTextColor;
  }

  return TextStyle(
    color: color,
    fontSize: Dimen.dateTextSize,
    fontWeight: FontWeight.w500,
  );
}

TextStyle defaultDayTextStyle({
  bool disabled = false,
  bool isSelected = false,
}) {
  var color = _DateColors.defaultMonthColor;
  if (disabled) {
    color = _DateColors.disabledColor;
  } else if (isSelected) {
    color = _DateColors.selectedTextColor;
  }

  return TextStyle(
    color: color,
    fontSize: Dimen.dayTextSize,
    fontWeight: FontWeight.w500,
  );
}

typedef DateSelectionCallback = void Function(DateTime selectedDate);
typedef DateChangeListener = void Function(DateTime selectedDate);

class Dimen {
  Dimen._();

  static const double dateTextSize = 24;
  static const double dayTextSize = 11;
  static const double monthTextSize = 11;
}
