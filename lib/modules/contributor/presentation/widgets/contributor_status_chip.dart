import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class ContributorStatusChip extends StatelessWidget {
  const ContributorStatusChip({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.h12,
        vertical: AppSpacing.v6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all08,
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: textColor),
      ),
    );
  }
}
