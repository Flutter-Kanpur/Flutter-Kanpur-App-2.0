import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  final _termsOfServices1 =
      'By accessing or using the Flutter Kanpur app, you agree to follow these terms. These terms help ensure a safe and respectful experience for all community members.';
  final _termsOfServices2 =
      'Flutter Kanpur provides access to community features such as events, contests, learning activities, and contributor tools. You are responsible for how you use these features and for ensuring that your activity follows community guidelines and applicable laws.';
  final _termsOfServices3 =
      'You agree not to misuse the app, attempt to disrupt services, or engage in behavior that harms other members or the community. Any content you submit, including messages, submissions, or contributions, should be appropriate and respectful.';
  final _termsOfServices4 =
      'Contributor access and community roles are granted based on application review and may be modified or revoked if guidelines are violated. Flutter Kanpur reserves the right to update or discontinue features as the community evolves. We may update these terms from time to time to reflect changes in features or policies. Continued use of the app after updates indicates acceptance of the revised terms.';

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
          Text(_termsOfServices1, style: usedTextTheme),
          const SizedBox(height: 28),
          Text(_termsOfServices2, style: usedTextTheme),
          const SizedBox(height: 28),
          Text(_termsOfServices3, style: usedTextTheme),
          const SizedBox(height: 28),
          Text(_termsOfServices4, style: usedTextTheme),
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
                    "If you do not agree with these terms, you should stop using the app.",
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
