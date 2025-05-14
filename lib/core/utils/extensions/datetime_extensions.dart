import 'package:intl/intl.dart';

import '../../core.dart';

extension DateTimeExtension on DateTime {
  static const fixLocale = 'vi_VN';
  static const monthYearFormat = 'MM/yyyy';

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  String toWeekDayInVietnamese({bool isShortMode = false}) =>
      DateTimeHelper.getDayOfWeekVi(weekday, isShortMode: isShortMode);

  String toViStringLongMode() {
    switch (DateTime.now().difference(this).inDays) {
      case 0:
        return 'Hôm nay, ${DateFormat('dd/MM/yyyy').format(this)}';
      case 1:
        return 'Hôm qua, ${DateFormat('dd/MM/yyyy').format(this)}';
      case -1:
        return 'Ngày mai, ${DateFormat('dd/MM/yyyy').format(this)}';
      default:
        return '${toWeekDayInVietnamese(isShortMode: false)}, ${DateFormat('dd/MM/yyyy').format(this)}';
    }
  }

  String toWeekDayInViLongMode() =>
      '${toWeekDayInVietnamese(isShortMode: false)}, ${DateFormat('dd/MM/yyyy').format(this)}';

  String toViStringMonthYear() => DateFormat(monthYearFormat, fixLocale).format(this);
}
