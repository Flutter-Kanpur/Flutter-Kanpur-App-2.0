import 'package:easy_localization/easy_localization.dart';

extension LocalizedDateExtensions on DateTime {
  String monthName() => 'months.${this.month}'.tr();

  String formattedLocalizedDate() =>
      '${'months.${this.month}'.tr()} ${this.day}, ${this.year}';
}
