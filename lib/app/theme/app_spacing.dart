import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing design system (Spacing-00 … Spacing-10).
///
/// Base values are design px; [s00]–[s10] are ScreenUtil-scaled (`.r`)
/// for consistent use in padding, margin, and gaps.
class AppSpacing {
  AppSpacing._();

  // Design px (Spacing-00 … Spacing-10)
  static const double space00 = 0;
  static const double space01 = 2;
  static const double space02 = 4;
  static const double space03 = 6;
  static const double space04 = 8;
  static const double space05 = 10;
  static const double space06 = 12;
  static const double space07 = 16;
  static const double space08 = 18;
  static const double space09 = 20;
  static const double space10 = 22;

  /// Spacing-00 → 0px
  static double get s00 => space00;

  /// Spacing-01 → 2px
  static double get s01 => space01.r;

  /// Spacing-02 → 4px
  static double get s02 => space02.r;

  /// Spacing-03 → 6px
  static double get s03 => space03.r;

  /// Spacing-04 → 8px
  static double get s04 => space04.r;

  /// Spacing-05 → 10px
  static double get s05 => space05.r;

  /// Spacing-06 → 12px
  static double get s06 => space06.r;

  /// Spacing-07 → 16px
  static double get s07 => space07.r;

  /// Spacing-08 → 18px
  static double get s08 => space08.r;

  /// Spacing-09 → 20px
  static double get s09 => space09.r;

  /// Spacing-10 → 22px
  static double get s10 => space10.r;

  // --- EdgeInsets helpers ---

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static EdgeInsets get all00 => EdgeInsets.all(s00);
  static EdgeInsets get all01 => EdgeInsets.all(s01);
  static EdgeInsets get all02 => EdgeInsets.all(s02);
  static EdgeInsets get all03 => EdgeInsets.all(s03);
  static EdgeInsets get all04 => EdgeInsets.all(s04);
  static EdgeInsets get all05 => EdgeInsets.all(s05);
  static EdgeInsets get all06 => EdgeInsets.all(s06);
  static EdgeInsets get all07 => EdgeInsets.all(s07);
  static EdgeInsets get all08 => EdgeInsets.all(s08);
  static EdgeInsets get all09 => EdgeInsets.all(s09);
  static EdgeInsets get all10 => EdgeInsets.all(s10);

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);
}
