import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usedTextTheme = theme.textTheme.bodyLarge;
    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: 'About Flutter Kanpur',
            subtitle: '',
            leading: FkBackButton(),
          ),
          SizedBox(height: 28),
          Text("aboutUs.aboutUs1".tr(), style: usedTextTheme),
          SizedBox(height: 16),
          Text("aboutUs.aboutUs2".tr(), style: usedTextTheme),
          SizedBox(height: 16),
          Text("aboutUs.aboutUs3".tr(), style: usedTextTheme),
        ],
      ),
    );
  }
}
