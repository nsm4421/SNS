import 'package:timeago/timeago.dart' as timeago;

extension DatetimeExtension on DateTime {
  String get yyyymmdd {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  String get diffText => timeago.format(this, locale: 'en_short');
}
