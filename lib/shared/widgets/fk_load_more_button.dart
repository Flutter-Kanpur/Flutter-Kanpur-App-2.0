import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

/// Pagination pill - shared by the Projects and Contests screens.
class FkLoadMoreButton extends StatelessWidget {
  const FkLoadMoreButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.v6),
      child: Center(
        child: Material(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all09,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.all09,
            child: Container(
              padding: AppSpacing.symmetric(
                horizontal: AppSpacing.h18,
                vertical: AppSpacing.v10,
              ),
              decoration: BoxDecoration(
                border: AppBorders.allSecondary(),
                borderRadius: AppRadius.all09,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: AppColors.blackBase),
                  SizedBox(width: AppSpacing.h4),
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.blackBase),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
