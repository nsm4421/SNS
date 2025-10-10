import 'package:path/path.dart';

extension StringExtension on String {
  String get ext => extension(this);
}
