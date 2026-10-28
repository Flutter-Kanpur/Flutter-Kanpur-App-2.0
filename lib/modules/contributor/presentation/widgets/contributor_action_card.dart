import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContributorActionCard extends StatelessWidget {
  const ContributorActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconAsset,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  /// Optional SVG asset path that, when provided, replaces the default
  /// [icon] CircleAvatar with the asset rendered at its own design (e.g. a
  /// pre-styled circle + icon). Existing callers that don't pass this keep
  /// the original CircleAvatar rendering unchanged.
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.h16),
          decoration: BoxDecoration(
            color: AppColors.whiteBase,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppBorders.secondary),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconAsset != null
                  ? SvgPicture.asset(iconAsset!, width: 44.r, height: 44.r)
                  : Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary50,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        icon,
                        size: 20.r,
                        color: AppColors.primary500,
                      ),
                    ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral950,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutral400,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

