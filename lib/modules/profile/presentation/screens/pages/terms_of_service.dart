import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usedTextTheme = theme.textTheme.bodyLarge;
    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: "Terms of Service",
            subtitle: '',
            leading: FkBackButton(),
          ),
          SizedBox(height: AppSpacing.s10),
          Text("termsOfServices.termsOfServices1".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s10),
          Text("termsOfServices.termsOfServices2".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s10),
          Text("termsOfServices.termsOfServices3".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s10),
          Text("termsOfServices.termsOfServices4".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s10),
          Container(
            padding: AppSpacing.all04,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warning100,
              borderRadius: AppRadius.all02,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.s01),
                  child: Icon(
                    Icons.warning_rounded,
                    color: AppColors.warning600,
                  ),
                ),
                SizedBox(width: AppSpacing.s07),
                Expanded(
                  child: Text(
                    "termsOfServices.termsOfServicesWarning".tr(),
                    style: usedTextTheme?.copyWith(color: AppColors.warning600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
