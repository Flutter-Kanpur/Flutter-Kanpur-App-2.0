import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_knp_mobile_app_v2/utils/date_extensions.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

/// Scrollable header for home screen (date, greeting, actions). Use as first child in scroll view.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  String _getGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greetings.morning'.tr();
    if (hour < 17) return 'greetings.afternoon'.tr();
    return 'greetings.evening'.tr();
  }

  String _getFormattedDate() => DateTime.now().formattedLocalizedDate();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.h22, AppSpacing.h20, AppSpacing.h8, AppSpacing.h22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _getFormattedDate(),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
                ),
                4.verticalSpace,
                Text(
                  _getGreeting(context),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.blackBase,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(AssetsPath.notification, fit: BoxFit.cover),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: AppColors.blackBase,
          ),
        ],
      ),
    );
  }
}
