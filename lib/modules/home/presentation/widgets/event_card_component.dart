import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image with overlay status badge
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFF7F9FF),
                          const Color(0xFFEAF2FF),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    //padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                        horizontal: 14.w,
                        vertical: 7.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(status, style: textStyle_12SemiBoldWhite()),
                    ),
                  ),
                ],
              ),
            ),
          ),
         
          // Organization section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [10.verticalSpace],
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(title, style: textStyle_18BlackMedium()),
          ),
          10.verticalSpace,
          // Date/Time
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(dateTime, style: textStyle_13SemiBoldBlue()),
          ),
          10.verticalSpace,
          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              description,
              style: textStyle_13RegularGrey(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          18.verticalSpace,
          // Button section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: GradientButton(
                    onTap: onButtonPressed,
                    text: buttonText,
                    textStyle: textStyle_14SemiBoldWhite(),
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
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: Colors.grey[600],
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
