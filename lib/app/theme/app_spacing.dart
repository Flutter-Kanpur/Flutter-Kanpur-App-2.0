import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// App spacing.
///
/// - [h2]–[h22] → horizontal (width, left, right)
/// - [v2]–[v22] → vertical (height, top, bottom)
///
/// The number is the design px value.
///
/// ```dart
/// SizedBox(width: AppSpacing.h16)
/// SizedBox(height: AppSpacing.v12)
/// padding: EdgeInsets.symmetric(
///   horizontal: AppSpacing.h20,
///   vertical: AppSpacing.v8,
/// )
/// ```
abstract class AppSpacing {
  AppSpacing._();

  // ── Horizontal (width / left / right) ─────────────────────────────────────
  static double get h2 => 2.r;
  static double get h4 => 4.r;
  static double get h6 => 6.r;
  static double get h8 => 8.r;
  static double get h10 => 10.r;
  static double get h12 => 12.r;
  static double get h16 => 16.r;
  static double get h18 => 18.r;
  static double get h20 => 20.r;
  static double get h22 => 22.r;

  // ── Vertical (height / top / bottom) ──────────────────────────────────────
  static double get v2 => 2.r;
  static double get v4 => 4.r;
  static double get v6 => 6.r;
  static double get v8 => 8.r;
  static double get v10 => 10.r;
  static double get v12 => 12.r;
  static double get v16 => 16.r;
  static double get v18 => 18.r;
  static double get v20 => 20.r;
  static double get v22 => 22.r;

  /// Unscaled 16px — only for rare `const` defaults.
  static const double raw16 = 16;
  static const double raw12 = 12;

  // ── EdgeInsets helpers ────────────────────────────────────────────────────

  static EdgeInsets all(double value) => EdgeInsets.all(value);

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);
}
