import 'package:intl/intl.dart';

/// Date and time formatting helpers
class DateFormatter {
  DateFormatter._();

  static final _timeFormat = DateFormat('h:mm a');
  static final _shortTime = DateFormat('h a');
  static final _dayFormat = DateFormat('EEE');
  static final _fullDayFormat = DateFormat('EEEE');
  static final _dateFormat = DateFormat('d MMM');
  static final _fullDateFormat = DateFormat('d MMMM yyyy');
  static final _dateTimeFormat = DateFormat('d MMM, h:mm a');

  /// "3:45 PM"
  static String time(DateTime dt) => _timeFormat.format(dt);

  /// "3 PM"
  static String shortTime(DateTime dt) => _shortTime.format(dt);

  /// "Mon"
  static String dayShort(DateTime dt) => _dayFormat.format(dt);

  /// "Monday"
  static String dayFull(DateTime dt) => _fullDayFormat.format(dt);

  /// "15 Jun"
  static String dateShort(DateTime dt) => _dateFormat.format(dt);

  /// "15 June 2026"
  static String dateFull(DateTime dt) => _fullDateFormat.format(dt);

  /// "15 Jun, 3:45 PM"
  static String dateTime(DateTime dt) => _dateTimeFormat.format(dt);

  /// "Today" / "Tomorrow" / "Mon"
  static String relativeDay(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    return _dayFormat.format(dt);
  }

  /// "Updated 5 min ago" / "Updated 2 hours ago"
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return dateShort(dt);
  }

  /// Checks if datetime is "now" hour
  static bool isCurrentHour(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year &&
        dt.month == now.month &&
        dt.day == now.day &&
        dt.hour == now.hour;
  }
}
