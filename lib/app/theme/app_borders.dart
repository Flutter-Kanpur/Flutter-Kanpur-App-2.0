import 'package:flutter/material.dart';

/// Border stroke design system.
///
/// Usage:
/// ```dart
/// Border.all(color: AppBorders.primary)
/// AppBorders.allSecondary()
/// ```
abstract class AppBorders {
  AppBorders._();

  /// Blue Border — #4167F2
  static const Color blue = Color(0xFF4167F2);

  /// Primary Border — #D1D1D1
  static const Color primary = Color(0xFFD1D1D1);

  /// Secondary Border — #E3E3E3
  static const Color secondary = Color(0xFFE3E3E3);

  /// Tertiary Border — #F4F4F4
  static const Color tertiary = Color(0xFFF4F4F4);

  static Border allBlue({double width = 1.0}) =>
      Border.all(color: blue, width: width);

  static Border allPrimary({double width = 1.0}) =>
      Border.all(color: primary, width: width);

  static Border allSecondary({double width = 1.0}) =>
      Border.all(color: secondary, width: width);

  static Border allTertiary({double width = 1.0}) =>
      Border.all(color: tertiary, width: width);
}
