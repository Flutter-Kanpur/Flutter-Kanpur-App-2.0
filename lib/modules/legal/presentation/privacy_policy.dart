import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
                translate(context, "profile_privacy_policy.title"),
                style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w600)),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              spacing: AppSpacing.s05,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContentContainer(
                  showBackground: false,
                  body: translate(
                      context, "profile_privacy_policy.body_1"),
                ),
                _buildContentContainer(
                  showBackground: false,
                  body: translate(
                      context, "profile_privacy_policy.body_2"),
                ),
                _buildContentContainer(
                  showBackground: false,
                  body: translate(
                      context, "profile_privacy_policy.body_3"),
                ),
                _buildContentContainer(
                  showBackground: false,
                  body: translate(
                      context, "profile_privacy_policy.body_4"),
                ),
                _buildContentContainer(
                  showBackground: false,
                  body: translate(
                      context, "profile_privacy_policy.body_5"),
                ),
                _buildLastUpdatedWidget(context)
              ],
            ),
          ),
        ));
  }
}

Widget _buildContentContainer(
    {String? title, required String body, bool showBackground = true}) {
  return Container(
    decoration: !showBackground
        ? null
        : BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all05),
    width: double.infinity,
    padding: !showBackground
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s05),
    margin: EdgeInsets.only(left: AppSpacing.s05, right: AppSpacing.s05),
    child: Column(
      spacing: AppSpacing.s04,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title.isNotEmpty)
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)
                .copyWith(fontWeight: FontWeight.w500),
          ),
        Text(
          body,
          style: AppTextStyles.bodyLarge.copyWith(height: 1.5),
        )
      ],
    ),
  );
}

Widget _buildLastUpdatedWidget(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(left: AppSpacing.s05, right: AppSpacing.s05),
    padding: EdgeInsets.only(bottom: AppSpacing.s05),
    child: Text(
      translate(context, "profile_privacy_policy.last_updated"),
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase)
          .copyWith(fontWeight: FontWeight.w400),
    ),
  );
}