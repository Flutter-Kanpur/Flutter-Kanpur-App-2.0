import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ContributorInfoBanner extends StatelessWidget {
  const ContributorInfoBanner({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.primary50,
    this.textColor = AppColors.neutral500,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(horizontal: AppSpacing.s08, vertical: AppSpacing.s08),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all04,
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
