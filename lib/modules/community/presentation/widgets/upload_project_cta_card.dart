import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';

/// Lavender "Upload project" call-to-action card, used on both the projects
/// list and a project's detail screen with different copy. Takes `onPressed`
/// rather than a route itself, same as [FkPrimaryButton], so it isn't tied to
/// a specific caller's navigation method (`.go` vs `.push`).
class UploadProjectCtaCard extends StatelessWidget {
  const UploadProjectCtaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(AppSpacing.h22),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: AppRadius.all04,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: AppSpacing.v10),
          Text(subtitle, textAlign: TextAlign.center),
          SizedBox(height: AppSpacing.v18),
          SizedBox(
            // Wide enough for the longer of the two labels this card ships
            // with ("Upload a new project") to stay on one line - shared by
            // both callers, so they stay visually consistent with each other.
            width: 260,
            child: FkPrimaryButton(
              label: buttonLabel,
              icon: null,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
