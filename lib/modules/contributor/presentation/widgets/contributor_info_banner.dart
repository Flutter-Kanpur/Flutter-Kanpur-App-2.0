import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class ContributorInfoBanner extends StatelessWidget {
  const ContributorInfoBanner({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.communityGuidelinesBackground,
    this.textColor = AppColors.subtitleTextDarkGrey,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: textColor, height: 1.5),
      ),
    );
  }
}
