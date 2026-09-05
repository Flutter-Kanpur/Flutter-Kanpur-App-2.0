import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import '../../../shared/widgets/fk_back_button.dart';
import '../../../shared/widgets/fk_header.dart';
import '../../../shared/widgets/fk_screen.dart';
import '../../../shared/widgets/gradient_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class AboutFlutterKanpur extends StatelessWidget {
  const AboutFlutterKanpur({super.key});

  @override
  Widget build(BuildContext context) {
    final usedTextTheme = AppTextStyles.titleMedium;
    return GradientBackground(
      child: FkScreen(
  padding: EdgeInsets.fromLTRB(
    AppSpacing.h16,
    AppSpacing.h18,
    AppSpacing.h16,
    24,
  ),
  children: [
          FkHeader(
            	
title: 'profile.aboutFlutterKanpur'.tr(),
            leading: FkBackButton(),
          ),
          SizedBox(height: AppSpacing.v22),
          Text("aboutUs.aboutUs1".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.v16),
          Text("aboutUs.aboutUs2".tr(), style: usedTextTheme),
          SizedBox(height: AppSpacing.v16),
          Text("aboutUs.aboutUs3".tr(), style: usedTextTheme),
        ],
      ),
    );
  }
}
