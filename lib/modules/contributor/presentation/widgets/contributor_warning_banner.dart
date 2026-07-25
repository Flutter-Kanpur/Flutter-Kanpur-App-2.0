import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ContributorWarningBanner extends StatelessWidget {
  const ContributorWarningBanner({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  final String message;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.all03,
      ),
      child: Row(
        children: [
          Icon(Icons.info, size: 18, color: iconColor),
          SizedBox(width: AppSpacing.h10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
