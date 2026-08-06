import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class EventCardComponent extends StatelessWidget {
  const EventCardComponent({
    super.key,
    required this.assetPath,
    required this.status,
    required this.statusColor,
    required this.organization,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.buttonText,
    required this.onButtonPressed,
    this.showEyeIcon = true,
    this.onEyeIconPressed,
  });

  /// Path to the image asset (e.g., 'assets/launch_event.png')
  final String assetPath;

  /// Status text (e.g., 'Upcoming', 'Ongoing')
  final String status;

  /// Color for the status badge
  final Color statusColor;

  /// Organization name (e.g., 'Flutter Kanpur')
  final String organization;

  /// Event title (e.g., 'Launch Event')
  final String title;

  /// Event description
  final String description;

  /// Date and time info (e.g., 'Sun, 7 Apr • 4:00 PM • Kanpur')
  final String dateTime;

  /// Button text (e.g., 'Join live')
  final String buttonText;

  /// Callback when button is pressed
  final VoidCallback onButtonPressed;

  /// Whether to show eye icon on button (optional)
  final bool showEyeIcon;

  /// Callback when eye icon is pressed (optional)
  final VoidCallback? onEyeIconPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all06,
        border: Border.all(color: AppBorders.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image with overlay status badge
          Padding(
            padding: AppSpacing.only(
              left: AppSpacing.h16,
              top: AppSpacing.v16,
              right: AppSpacing.h16,
              bottom: AppSpacing.v12,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.all05,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.all05,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary50, AppColors.primary50],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    //padding: AppSpacing.symmetric(horizontal: AppSpacing.h4, vertical: AppSpacing.v2),
                    child: Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.h16,
                        vertical: AppSpacing.v16,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: AppRadius.all09,
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.whiteBase,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Organization section
          Padding(
            padding: AppSpacing.horizontal(AppSpacing.h20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [10.verticalSpace],
            ),
          ),
          // Title
          Padding(
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          10.verticalSpace,
          // Date/Time
          Padding(
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: Text(
              dateTime,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          10.verticalSpace,
          // Description
          Padding(
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral400,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          18.verticalSpace,
          // Button section
          Padding(
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    onTap: onButtonPressed,
                    text: buttonText,
                    textStyle: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.whiteBase,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showEyeIcon) ...[
                  12.horizontalSpace,
                  GestureDetector(
                    onTap: onEyeIconPressed,
                    child: Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppBorders.primary,
                          width: 1.5,
                        ),
                        borderRadius: AppRadius.all09,
                      ),
                      child: Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
