import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/my_contests_state.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

/// Card for a single contest on the My Contests screen: category label +
/// favorite heart, title, skill/format tags, and an ends-in/starts-in/ended-on
/// meta row with the primary action button.
class MyContestCard extends StatelessWidget {
  const MyContestCard({
    super.key,
    required this.contest,
    required this.onToggleSaved,
    required this.onAction,
    required this.onTap,
  });

  final MyContest contest;
  final VoidCallback onToggleSaved;
  final VoidCallback onAction;

  /// Opens the contest's detail screen. Tapping the bookmark icon or the
  /// action button below doesn't trigger this — each already has its own
  /// tap handler, which claims the gesture before it reaches this one.
  final VoidCallback onTap;

  TextStyle _metaValueStyle() {
    return switch (contest.metaTone) {
      MyContestMetaTone.urgent => AppTextStyles.bodyLarge.copyWith(color: AppColors.warning600),
      MyContestMetaTone.positive =>
        AppTextStyles.bodyLarge.copyWith(color: AppColors.success600),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all05,
        child: Container(
          padding: AppSpacing.all(AppSpacing.h16),
          decoration: BoxDecoration(
            color: AppColors.whiteBase,
            borderRadius: AppRadius.all05,
            border: Border.all(color: AppBorders.primary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(contest.categoryLabel, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500)),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onToggleSaved,
                    icon: Icon(
                      contest.isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: contest.isSaved
                          ? AppColors.primary500
                          : AppColors.neutral500,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.v8),
              Text(contest.title, style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500)),
              SizedBox(height: AppSpacing.v12),
              Wrap(
                spacing: AppSpacing.h8,
                runSpacing: AppSpacing.v8,
                children: contest.tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.h16,
                          vertical: AppSpacing.v8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral50,
                          borderRadius: AppRadius.all09,
                        ),
                        child: Text(tag, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase)),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: AppSpacing.v16),
              Divider(
                height: 1,
                thickness: 1,
                color: AppBorders.primary,
              ),
              SizedBox(height: AppSpacing.v16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contest.metaLabel,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
                        ),
                        SizedBox(height: AppSpacing.v4),
                        Text(contest.metaValue, style: _metaValueStyle()),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 160.w,
                    child: GradientButton(
                      text: contest.actionLabel,
                      height: 44.h,
                      onTap: onAction,
                      textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.whiteBase, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
