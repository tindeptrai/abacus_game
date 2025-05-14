import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getDayOfWeekVi(int dayOfWeek, {bool isShortMode = false}) {
    switch (dayOfWeek) {
      case 1:
        return isShortMode ? 'T2' : 'Thứ 2';
      case 2:
        return isShortMode ? 'T3' : 'Thứ 3';
      case 3:
        return isShortMode ? 'T4' : 'Thứ 4';
      case 4:
        return isShortMode ? 'T5' : 'Thứ 5';
      case 5:
        return isShortMode ? 'T6' : 'Thứ 6';
      case 6:
        return isShortMode ? 'T7' : 'Thứ 7';
      case 7:
        return isShortMode ? 'CN' : 'Chủ nhật';
      default:
        return '';
    }
  }

  static DateTime? tryParseFromDDMMYYYY(String? dateString) {
    if (dateString == null) return null;
    try {
      final f = DateFormat('dd/MM/yyyy');
      return f.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}
