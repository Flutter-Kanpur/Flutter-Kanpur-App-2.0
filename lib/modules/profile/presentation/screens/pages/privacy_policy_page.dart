import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  final _privacy1 =
      'Flutter Kanpur respects your privacy and is committed to protecting your personal information. This policy explains how we collect, use, and safeguard data when you use our app and services.';
  final _privacy2 =
      'When you create an account, we may collect basic information such as your name, email address, and profile details. This information is used only to provide core features like events, contests, contributor access, and personalized experiences within the app.';
  final _privacy3 =
      'We do not sell, trade, or misuse your personal data. Information shared within the community, such as profile details or contributions, is visible only according to your privacy settings. Sensitive information like login credentials is securely handled and never shared publicly.';
  final _privacy4 =
      'We may collect limited usage data to improve app performance, fix issues, and understand how features are used. This data is analyzed in aggregate and does not identify individual users.';
  final _privacy5 =
      ' You can update or delete your account information at any time from the app settings. If you have questions or concerns about your data, you can contact the Flutter Kanpur team directly. By using the app, you agree to the practices described in this policy.';

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
          const SizedBox(height: 28),
          Text(_privacy1, style: usedTextTheme),
          const SizedBox(height: 16),
          Text(_privacy2, style: usedTextTheme),
          const SizedBox(height: 16),
          Text(_privacy3, style: usedTextTheme),
          const SizedBox(height: 16),
          Text(_privacy4, style: usedTextTheme),
          const SizedBox(height: 16),
          Text(_privacy5, style: usedTextTheme),
          const SizedBox(height: 16),
          Text("Last updated: April 2026", style: usedTextTheme),
        ],
      ),
    );
  }
}
