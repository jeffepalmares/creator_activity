import 'package:commons_flutter/utils/app_date_utils.dart';

abstract class LibDateUtils extends AppDateUtils {
  static DateTime addDay(DateTime date, int qtd) {
    return date.add(Duration(days: qtd));
  }

  static bool isSameDate(DateTime first, DateTime other) {
    return first.year == other.year &&
        first.month == other.month &&
        first.day == other.day;
  }

  static bool isBetween(DateTime? date, {DateTime? start, DateTime? end}) {
    date = date ?? DateTime.now();
    start = start ?? DateTime.now();
    end = end ?? DateTime.now();
    return (date.isAfter(start) || isSameDate(date, start)) &&
        (date.isBefore(end) || isSameDate(date, end));
  }

  static DateTime getFirstDayOfLastMonth() {
    var firstDay = getLastDayOfLastMonth();
    firstDay = DateTime(firstDay.year, firstDay.month, 1);
    return firstDay;
  }

  static DateTime getLastDayOfLastMonth() {
    var now = DateTime.now();
    now = DateTime(now.year, now.month, 0);
    return now;
  }

  static DateTime getFirstDayOfCurrentMonth() {
    var now = DateTime.now();

    return DateTime(now.year, now.month, 1);
  }

  static DateTime getLastDayOfCurrentMonth() {
    var now = DateTime.now();

    return DateTime(now.year, now.month + 1, 0);
  }

  static DateTime getFirstDayOfCurrentYear() {
    var now = DateTime.now();

    return DateTime(now.year, 1, 1);
  }

  static DateTime getLastDayOfCurrentYear() {
    var now = DateTime.now();

    return DateTime(now.year, 12, 31);
  }

  static DateTime getFirstDayOfLastYear() {
    var now = DateTime.now();

    return DateTime(now.year - 1, 1, 1);
  }

  static DateTime getLastDayOfLastYear() {
    var now = DateTime.now();

    return DateTime(now.year - 1, 12, 31);
  }

  static DateTime getFirstDayOfCurrentWeek({bool isSunday = false}) {
    var now = DateTime.now();
    var subtractDays = 0;
    if (now.weekday == DateTime.sunday && isSunday) {
      subtractDays = 0;
    } else if (!isSunday) {
      subtractDays = now.weekday - 1;
    } else {
      subtractDays = now.weekday;
    }

    return now.subtract(Duration(days: subtractDays));
  }

  static DateTime getLastDayOfCurrentWeek({bool isSunday = false}) {
    var firstDay = getFirstDayOfCurrentWeek(isSunday: isSunday);

    return firstDay.add(const Duration(days: 6));
  }

  static DateTime getFirstDayOfLastWeek({bool isSunday = false}) {
    var firstDayCurrentWeek = getFirstDayOfCurrentWeek(isSunday: isSunday);
    return firstDayCurrentWeek.subtract(const Duration(days: 7));
  }

  static DateTime getLastDayOfLastWeek({bool isSunday = false}) {
    var firstDayCurrentWeek = getFirstDayOfLastWeek(isSunday: isSunday);

    return firstDayCurrentWeek.add(const Duration(days: 6));
  }
}
