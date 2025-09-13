import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  String get toKoTimeFormat => timeago.format(this, locale: 'ko');
}
