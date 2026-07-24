import 'package:flutter/material.dart';

/// App color design system.
///
/// Usage:
/// ```dart
/// AppColors.whiteBase
/// AppColors.primary500
/// AppColors.neutral50
/// AppColors.success600
/// AppColors.pending400
/// AppColors.warning600
/// ```
abstract class AppColors {
  AppColors._();

  // ── Base ──────────────────────────────────────────────────────────────────
  /// White Base — #FFFFFF
  static const Color whiteBase = Color(0xFFFFFFFF);

  /// Black Base — #000000
  static const Color blackBase = Color(0xFF000000);

  // ── Primary (locked: 500) ─────────────────────────────────────────────────
  static const Color primary50 = Color(0xFFEFF3FF);
  static const Color primary100 = Color(0xFFDCE5FD);
  static const Color primary200 = Color(0xFFC0D1FD);
  static const Color primary300 = Color(0xFF95B4FB);
  static const Color primary400 = Color(0xFF638DF7);
  static const Color primary500 = Color(0xFF4167F2);
  static const Color primary600 = Color(0xFF2946E7);
  static const Color primary700 = Color(0xFF2132D4);
  static const Color primary800 = Color(0xFF212BAC);
  static const Color primary900 = Color(0xFF202A98);
  static const Color primary950 = Color(0xFF181C53);

  // ── Neutral (locked: 950) ─────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFF6F6F6);
  static const Color neutral100 = Color(0xFFE7E7E7);
  static const Color neutral200 = Color(0xFFD1D1D1);
  static const Color neutral300 = Color(0xFFB0B0B0);
  static const Color neutral400 = Color(0xFF888888);
  static const Color neutral500 = Color(0xFF6D6D6D);
  static const Color neutral600 = Color(0xFF5D5D5D);
  static const Color neutral700 = Color(0xFF4F4F4F);
  static const Color neutral800 = Color(0xFF454545);
  static const Color neutral900 = Color(0xFF3D3D3D);
  static const Color neutral950 = Color(0xFF000000);

  // ── Success (locked: 600) ─────────────────────────────────────────────────
  static const Color success50 = Color(0xFFEAFFF5);
  static const Color success100 = Color(0xFFCDFEE4);
  static const Color success200 = Color(0xFFA0FACF);
  static const Color success300 = Color(0xFF63F2B6);
  static const Color success400 = Color(0xFF25E299);
  static const Color success500 = Color(0xFF00B374);
  static const Color success600 = Color(0xFF00A46B);
  static const Color success700 = Color(0xFF008359);
  static const Color success800 = Color(0xFF006748);
  static const Color success900 = Color(0xFF00553C);
  static const Color success950 = Color(0xFF003023);

  // ── Pending (locked: 400) ─────────────────────────────────────────────────
  static const Color pending50 = Color(0xFFFDF7E9);
  static const Color pending100 = Color(0xFFFBEDC6);
  static const Color pending200 = Color(0xFFF9D88F);
  static const Color pending300 = Color(0xFFF3B239);
  static const Color pending400 = Color(0xFFEF9F20);
  static const Color pending500 = Color(0xFFDF8713);
  static const Color pending600 = Color(0xFFC1650D);
  static const Color pending700 = Color(0xFF9A460E);
  static const Color pending800 = Color(0xFF7F3914);
  static const Color pending900 = Color(0xFF6C2F17);
  static const Color pending950 = Color(0xFF3F1609);

  // ── Warning (locked: 600) ─────────────────────────────────────────────────
  static const Color warning50 = Color(0xFFFDF3F3);
  static const Color warning100 = Color(0xFFFCE4E4);
  static const Color warning200 = Color(0xFFFACECE);
  static const Color warning300 = Color(0xFFF5ACAC);
  static const Color warning400 = Color(0xFFED7C7C);
  static const Color warning500 = Color(0xFFE15252);
  static const Color warning600 = Color(0xFFCC3333);
  static const Color warning700 = Color(0xFFAC2929);
  static const Color warning800 = Color(0xFF8E2626);
  static const Color warning900 = Color(0xFF772525);
  static const Color warning950 = Color(0xFF400F0F);
}
