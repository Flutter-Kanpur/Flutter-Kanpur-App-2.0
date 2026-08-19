import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';

/// "Upload project" CTA card, used on both the projects list and detail
/// screen with different copy.
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
