import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'badge_icon.dart';

/// Earned badges get the blue "Earned on" card; locked ones the white
/// progress card. Tap outside or back to close.
Future<void> showBadgeDetailDialog(
  BuildContext context,
  AchievementBadge badge,
) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.blackBase.withValues(alpha: 0.55),
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 36.w),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: badge.isEarned
            ? _EarnedBadgeCard(badge: badge)
            : _LockedBadgeCard(badge: badge),
      ),
    ),
  );
}

class _EarnedBadgeCard extends StatelessWidget {
  const _EarnedBadgeCard({required this.badge});

  final AchievementBadge badge;

  @override
  Widget build(BuildContext context) {
    final earnedAt = badge.earnedAt;
    final light = AppColors.whiteBase.withValues(alpha: 0.85);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h20,
        vertical: AppSpacing.v22,
      ),
      decoration: BoxDecoration(
        borderRadius: AppRadius.all06,
        gradient: const RadialGradient(
          radius: 0.9,
          colors: [AppColors.primary200, AppColors.primary500],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DialogTitle(text: badge.title, color: AppColors.whiteBase),
          if (badge.description.isNotEmpty) ...[
            SizedBox(height: AppSpacing.v8),
            _DialogBody(text: badge.description, color: light),
          ],
          SizedBox(height: AppSpacing.v20),
          BadgeIcon(iconUrl: badge.iconUrl, size: 104.r),
          SizedBox(height: AppSpacing.v20),
          if (earnedAt != null) ...[
            Text(
              'badges.earnedOnLabel'.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.whiteBase,
              ),
            ),
            SizedBox(height: AppSpacing.v8),
            Text(
              DateFormat('MMM d, yyyy').format(earnedAt),
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.whiteBase,
                fontWeight: FontWeight.w500,
              ),
            ),
          ] else
            Text(
              'badges.earned'.tr(),
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.whiteBase,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (badge.earnedMessage.isNotEmpty) ...[
            SizedBox(height: AppSpacing.v16),
            _DialogBody(text: badge.earnedMessage, color: light),
          ],
        ],
      ),
    );
  }
}

class _LockedBadgeCard extends StatelessWidget {
  const _LockedBadgeCard({required this.badge});

  final AchievementBadge badge;

  String get _encouragement {
    if (badge.currentCount == 0) return 'badges.getStarted'.tr();
    if (badge.remainingCount <= 0) return 'badges.awaitingAward'.tr();
    if (badge.remainingCount == 1) return 'badges.almostThere'.tr();
    return 'badges.keepGoing'.tr(args: ['${badge.remainingCount}']);
  }

  @override
  Widget build(BuildContext context) {
    final howToEarn = badge.howToEarn.isNotEmpty
        ? badge.howToEarn
        : badge.description;
    final progress = [
      '${badge.currentCount}/${badge.targetCount}',
      if (badge.progressUnit.isNotEmpty) badge.progressUnit,
    ].join(' ');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h20,
        vertical: AppSpacing.v22,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all06,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DialogTitle(text: badge.title, color: AppColors.blackBase),
          if (howToEarn.isNotEmpty) ...[
            SizedBox(height: AppSpacing.v8),
            _DialogBody(text: howToEarn, color: AppColors.neutral500),
          ],
          SizedBox(height: AppSpacing.v20),
          BadgeIcon(iconUrl: badge.iconUrl, size: 104.r, locked: true),
          SizedBox(height: AppSpacing.v20),
          Text(
            'badges.progress'.tr(args: [progress]),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral700,
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          _ProgressBar(fraction: badge.progressFraction),
          SizedBox(height: AppSpacing.v16),
          _DialogBody(text: _encouragement, color: AppColors.neutral500),
        ],
      ),
    );
  }
}

/// Rounded bar with the shield marker at its end, as in the locked design.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadius.all09,
            child: LinearProgressIndicator(
              value: fraction.clamp(0.0, 1.0),
              minHeight: 8.r,
              backgroundColor: AppColors.primary100,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary500),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.h6),
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary50,
            border: Border.all(color: AppColors.primary200),
          ),
          child: Icon(
            Icons.shield_rounded,
            size: 16.r,
            color: AppColors.primary500,
          ),
        ),
      ],
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.titleLarge.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DialogBody extends StatelessWidget {
  const _DialogBody({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.bodyMedium.copyWith(color: color, height: 1.4),
    );
  }
}
