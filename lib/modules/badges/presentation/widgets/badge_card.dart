import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'badge_icon.dart';

/// Grid tile on Your Badges: artwork, title and "Earned on Apr 10" / "Locked".
class BadgeCard extends StatelessWidget {
  const BadgeCard({super.key, required this.badge, required this.onTap});

  final AchievementBadge badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locked = badge.isLocked;
    final earnedAt = badge.earnedAt;
    final subtitle = locked
        ? 'badges.locked'.tr()
        : earnedAt == null
        ? 'badges.earned'.tr()
        : 'badges.earnedOn'.tr(args: [DateFormat('MMM d').format(earnedAt)]);

    return Semantics(
      button: true,
      label: '${badge.title}, $subtitle',
      excludeSemantics: true,
      child: Material(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all04,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.all04,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: AppRadius.all04,
              border: Border.all(
                color: locked ? AppColors.neutral100 : AppColors.primary100,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary500.withValues(
                    alpha: locked ? 0.04 : 0.08,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.h10,
                vertical: AppSpacing.v16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BadgeIcon(iconUrl: badge.iconUrl, size: 72.r, locked: locked),
                  SizedBox(height: AppSpacing.v12),
                  Text(
                    badge.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: locked
                          ? AppColors.neutral300
                          : AppColors.blackBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.v2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: locked
                          ? AppColors.neutral300
                          : AppColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
