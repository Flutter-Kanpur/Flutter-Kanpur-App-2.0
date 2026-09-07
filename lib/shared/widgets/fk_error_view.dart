import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import '../../utils/translate.dart';

/// Failed-to-load state with a retry affordance.
///
/// Same visual treatment as the private `_ErrorView` copies in the community
/// screens, but with the message parameterised and the button localized.
class FkErrorView extends StatelessWidget {
  const FkErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Column(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: AppColors.neutral400,
          ),
          SizedBox(height: AppSpacing.v12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          SizedBox(height: AppSpacing.v16),
          TextButton(
            onPressed: onRetry,
            child: Text(translate(context, 'profile.retry')),
          ),
        ],
      ),
    );
  }
}

/// Loaded-but-nothing-to-show state.
class FkEmptyView extends StatelessWidget {
  const FkEmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
        ),
      ),
    );
  }
}
