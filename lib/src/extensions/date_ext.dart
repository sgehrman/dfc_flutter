extension ExtendedDate on DateTime {
  // like now, but returns beginning of day
  DateTime floor() {
    return DateTime(year, month, day);
  }
}
