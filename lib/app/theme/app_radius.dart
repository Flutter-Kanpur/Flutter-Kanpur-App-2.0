import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Radius-corner design system (Radius-00 … Radius-09).
///
/// Usage:
/// ```dart
/// BorderRadius.circular(AppRadius.r04)
/// AppRadius.all05
/// ```
abstract class AppRadius {
  AppRadius._();

  // Design dp (Radius-00 … Radius-09)
  static const double radius00 = 0;
  static const double radius01 = 4;
  static const double radius02 = 8;
  static const double radius03 = 12;
  static const double radius04 = 16;
  static const double radius05 = 20;
  static const double radius06 = 28;
  static const double radius07 = 32;
  static const double radius08 = 46;
  static const double radius09 = 100;

  /// Radius-00 → 0dp (no corner)
  static double get r00 => radius00;

  /// Radius-01 → 4dp (xxs)
  static double get r01 => radius01.r;

  /// Radius-02 → 8dp (xs)
  static double get r02 => radius02.r;

  /// Radius-03 → 12dp (sm)
  static double get r03 => radius03.r;

  /// Radius-04 → 16dp (md)
  static double get r04 => radius04.r;

  /// Radius-05 → 20dp (lg)
  static double get r05 => radius05.r;

  /// Radius-06 → 28dp (xl)
  static double get r06 => radius06.r;

  /// Radius-07 → 32dp (xxl)
  static double get r07 => radius07.r;

  /// Radius-08 → 46dp (xxxl)
  static double get r08 => radius08.r;

  /// Radius-09 → 100dp (fully rounded)
  static double get r09 => radius09.r;

  static BorderRadius get all00 => BorderRadius.circular(r00);
  static BorderRadius get all01 => BorderRadius.circular(r01);
  static BorderRadius get all02 => BorderRadius.circular(r02);
  static BorderRadius get all03 => BorderRadius.circular(r03);
  static BorderRadius get all04 => BorderRadius.circular(r04);
  static BorderRadius get all05 => BorderRadius.circular(r05);
  static BorderRadius get all06 => BorderRadius.circular(r06);
  static BorderRadius get all07 => BorderRadius.circular(r07);
  static BorderRadius get all08 => BorderRadius.circular(r08);
  static BorderRadius get all09 => BorderRadius.circular(r09);

  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );
}
