import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

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
          const SizedBox(height: 28),
          Text("termsOfServices.termsOfServices1".tr(), style: usedTextTheme),
          const SizedBox(height: 28),
          Text("termsOfServices.termsOfServices2".tr(), style: usedTextTheme),
          const SizedBox(height: 28),
          Text("termsOfServices.termsOfServices3".tr(), style: usedTextTheme),
          const SizedBox(height: 28),
          Text("termsOfServices.termsOfServices4".tr(), style: usedTextTheme),
          const SizedBox(height: 32),
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.redWarningBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.warning_rounded,
                    color: AppColors.errorColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "termsOfServices.termsOfServicesWarning".tr(),
                    style: usedTextTheme?.copyWith(color: AppColors.redBgText),
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
