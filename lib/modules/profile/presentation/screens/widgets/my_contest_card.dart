import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/my_contests_state.dart';

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
      MyContestMetaTone.urgent => textStyle_16RedRegular(),
      MyContestMetaTone.positive => textStyle_16RegularBlack().copyWith(color: AppColors.green),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.communityBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(contest.categoryLabel, style: textStyle_14RegularGrey()),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onToggleSaved,
                    icon: Icon(
                      contest.isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: contest.isSaved ? AppColors.primary : AppColors.textGray,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(contest.title, style: textStyle_18BlackMedium()),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: contest.tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: AppColors.bgPrimary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(tag, style: textStyle_14RegularBlack()),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: 16.h),
              Divider(height: 1, thickness: 1, color: AppColors.contributorFieldBorder),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contest.metaLabel, style: textStyle_14RegularGrey()),
                        SizedBox(height: 4.h),
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
                      textStyle: textStyle_14SemiBoldWhite(),
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
