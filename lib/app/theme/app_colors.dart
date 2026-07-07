import 'package:flutter/material.dart';

/// Centralized color constants for the Flutter Kanpur Mobile App.
///
/// Use these instead of inline hex literals so colors are maintainable
/// and consistent across every feature. Synced with admin dashboard design system.
abstract class AppColors {
  // ── Brand Primary ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4167F2);
  static const Color purple = Color(0xFF9B59B6);
  static const Color green = Color(0xFF27AE60);
  static const Color orange = Color(0xFFE67E22);
  static const Color red = Color(0xFFE74C3C);
  static const Color teal = Color(0xFF16A085);
  static const Color amber = Color(0xFFF59E0B);
  static const Color blue = Color(0xFF13A4EC);

  /// Accent palette for badges/cards.
  static const List<Color> accents = [
    primary,
    purple,
    green,
    orange,
    red,
    teal,
  ];

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
  static const Color communityGuidelinesBackground = Color(0xFFEFF3FF);
  static const Color contributorGreenBackground = Color(0xFF30C85D);
  static const Color contributorGreenContainerBg = Color(0xFFCCEFD8);
  static const Color contributorTextGreen = Color(0xFF006748);
  static const Color applicationSubmittedBg = Color(0xFFDDF4E5);
  static const Color communityBorder = Color(0xFFE3E3E3);
  static const Color lightGrayText = Color(0xFFDADADA);

  // ── Warning & Field ─────────────────────────────────────────────────────
  static const Color yellowWarningBackground = Color(0xFFFDF7E9);
  static const Color yellowWarningText = Color(0xFFFEF9F2);
  static const Color contributorFieldBorder = Color(0xFFD1D1D1);
  static const Color contributorFocusFieldBorder = primary;
  static const Color contributorFieldHint = Color(0xFFB0B0B0);
  static const Color subtitleTextDarkGrey = Color(0xFF6D6D6D);

  // ── Profile & Sections ───────────────────────────────────────────────────
  static const Color profileSectionBackground = Color(0xFFF6F6F6);
  static const Color avatarBorder = Color(0xFFC9C9C9);
  static const Color avatarBackground = Color(0xFFE0E0E0);

  // ── Text Colors ──────────────────────────────────────────────────────────
  static const Color textWhite = Colors.white;
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
  static const Color bgSecondary = Color(0xFFF6F6F6);
  static const Color bgPrimary = Color(0xFFDCE5FD);
  static const Color avatarBackgroundColor = Color(0xFFE0E0E0);
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
  static Color statusContainer(Color status,
      {required bool isDark, double lightAlpha = 0.12, double darkAlpha = 0.22}) {
    return status.withValues(alpha: isDark ? darkAlpha : lightAlpha);
  }
}
