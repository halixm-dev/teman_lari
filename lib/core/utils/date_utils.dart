import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatPace(Duration pace) {
    final totalSeconds = pace.inSeconds;
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  static String formatDistance(double km) {
    return '${km.toStringAsFixed(2)} km';
  }

  static DateTime nextMonday() {
    final today = DateTime.now();
    final daysUntilMonday = (8 - today.weekday) % 7;
    return today.add(
      Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday),
    );
  }

  static String isoWeekKey(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return '${monday.year}-W${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }
}
