import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usedTextTheme = theme.textTheme.bodyLarge;
    return GradientBackground(
      child: FkScreen(
        children: [
          const FkHeader(
            title: 'Privacy Policy',
            subtitle: '',
            leading: FkBackButton(),
          ),
          SizedBox(height: AppSpacing.s10),
          Text("privacyPolicy.privacyPolicy1".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s07),
          Text("privacyPolicy.privacyPolicy2".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s07),
          Text("privacyPolicy.privacyPolicy3".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s07),
          Text("privacyPolicy.privacyPolicy4".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s07),
          Text("privacyPolicy.privacyPolicy5".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.s07),
          Text(
            "common.lastUpdated".tr(args: ["common.lastUpdatedDate".tr()]),
            style: usedTextTheme,
          ),
        ],
      ),
    );
  }
}
