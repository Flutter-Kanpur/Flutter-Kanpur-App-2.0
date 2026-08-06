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

  // ── Brand accents ─────────────────────────────────────────────────────────
  /// Brand primary — alias of [primary500].
  static const Color primary = primary500;
  static const Color purple = Color(0xFF9B59B6);
  static const Color green = Color(0xFF27AE60);
  static const Color orange = Color(0xFFE67E22);
  static const Color red = Color(0xFFE74C3C);
  static const Color teal = Color(0xFF16A085);
  static const Color amber = Color(0xFFF59E0B);
  static const Color blue = Color(0xFF13A4EC);

  /// Accent palette for badges / cards.
  static const List<Color> accents = [primary, purple, green, orange, red, teal];

  // ── Status — foreground ───────────────────────────────────────────────────
  static const Color successFg = Color(0xFF166534);
  static const Color warningFg = Color(0xFF92400E);
  static const Color errorFg = Color(0xFF991B1B);
  static const Color neutralFg = Color(0xFF475569);

  // ── Status — background ──────────────────────────────────────────────────
  static const Color successBg = Color(0xFFDDF4E5);
  static const Color warningBg = Color(0xFFFDF0D5);
  static const Color errorBg = Color(0xFFFDE2E1);
  static const Color neutralBg = Color(0xFFE2E8F0);

  // ── Navigation & UI ──────────────────────────────────────────────────────
  static const Color navBarBackground = Color(0xFFFAFCFF);
  static const Color unselectedNavBarIcon = Color(0xFFBCBCBC);
  static const Color selectedNavBarIcon = primary;

  // ── Community ────────────────────────────────────────────────────────────
  static const Color communityGuidelinesBackground = primary50;
  static const Color contributorGreenBackground = Color(0xFF30C85D);
  static const Color contributorGreenContainerBg = Color(0xFFCCEFD8);
  static const Color contributorTextGreen = success800;
  static const Color applicationSubmittedBg = Color(0xFFDDF4E5);
  static const Color communityBorder = Color(0xFFE3E3E3);
  static const Color lightGrayText = Color(0xFFDADADA);

  // ── Warning & Field ─────────────────────────────────────────────────────
  static const Color yellowWarningBackground = pending50;
  static const Color yellowWarningText = Color(0xFFFEF9F2);
  static const Color redWarningBackground = warning100;
  static const Color contributorFieldBorder = neutral200;
  static const Color contributorFocusFieldBorder = primary;
  static const Color contributorFieldHint = neutral300;
  static const Color subtitleTextDarkGrey = neutral500;

  // ── Profile & Sections ───────────────────────────────────────────────────
  static const Color profileSectionBackground = neutral50;
  static const Color avatarBorder = Color(0xFFC9C9C9);
  static const Color avatarBackground = Color(0xFFE0E0E0);

  // ── Text Colors ──────────────────────────────────────────────────────────
  static const Color textWhite = whiteBase;
  static const Color textGray = Color(0xFFA6A6A6);
  static const Color textGrey = Color(0xFF9E9E9E);
  static const Color borderSecondary = Color(0xFFE3E3E3);

  // ── Social Media ─────────────────────────────────────────────────────────
  static const Color githubColor = Color(0xFF333333);
  static const Color linkedinColor = Color(0xFF0077B5);

  // ── Status Colors (also used in community) ──────────────────────────────
  static const Color errorColor = red;
  static const Color loadingColor = blue;
  static const Color warningColor = orange;
  static const Color successColor = green;

  // ── Legacy Aliases (for backward compatibility) ──────────────────────────
  static const Color communityBorderColor = communityBorder;
  static const Color communityBorderColorV2 = communityBorder;
  static const Color unselectedNavBarIconColor = unselectedNavBarIcon;
  static const Color selectedNavBarIconColor = selectedNavBarIcon;
  static const Color navBarBackgroundColor = navBarBackground;
  static const Color communityGuidelinesContainerBackground =
      communityGuidelinesBackground;
  static const Color redBgText = red;
  static const Color bgSecondary = neutral50;
  static const Color bgPrimary = primary100;
  static const Color avatarBackgroundColor = avatarBackground;
  static const Color contributorFieldHintColor = contributorFieldHint;

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns the status foreground / background pair for a given [status].
  static ({Color fg, Color bg}) statusPair(String status) {
    return switch (status.trim().toLowerCase()) {
      'open' || 'active' || 'approved' || 'success' => (
        fg: successFg,
        bg: successBg,
      ),
      'pending' || 'review' || 'draft' => (fg: warningFg, bg: warningBg),
      'rejected' || 'closed' || 'cancelled' || 'error' => (
        fg: errorFg,
        bg: errorBg,
      ),
      _ => (fg: neutralFg, bg: neutralBg),
    };
  }

  /// Dark-mode aware version of status backgrounds — lightens alpha in dark.
  static Color statusContainer(
    Color status, {
    required bool isDark,
    double lightAlpha = 0.12,
    double darkAlpha = 0.22,
  }) {
    return status.withValues(alpha: isDark ? darkAlpha : lightAlpha);
  }
}
