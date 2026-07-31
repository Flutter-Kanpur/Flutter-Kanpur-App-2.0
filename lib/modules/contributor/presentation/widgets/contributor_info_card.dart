import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class ContributorInfoCard extends StatelessWidget {
  const ContributorInfoCard({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textColor = AppColors.blackBase,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.h20,
        vertical: AppSpacing.v18,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all04,
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }
}
