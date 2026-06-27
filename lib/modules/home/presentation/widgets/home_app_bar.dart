import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_knp_mobile_app_v2/utils/date_extensions.dart';

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
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 8.w, 25.h),
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
                  style: textStyle_14MediumGreyHintStyle(),
                ),
                4.verticalSpace,
                Text(
                  _getGreeting(context),
                  style: textStyle_16RegularBlack().copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SvgPicture.asset(AssetsPath.notification, fit: BoxFit.cover),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
            color: const Color(0xFF111827),
          ),
        ],
      ),
    );
  }
}
