import 'package:timeago/timeago.dart' as timeago;

extension DatetimeExtension on DateTime {
  String get yyyymmdd {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y$m$d';
  }

  String get diffTextEn => timeago.format(toLocal(), locale: 'en');

  String get diffTextEnShort => timeago.format(toLocal(), locale: 'en_short');
}
