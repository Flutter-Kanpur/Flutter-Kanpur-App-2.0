import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/community_error_message.dart';

/// Full-width error state with a retry action.
///
/// Consolidates the `_ErrorView` / `_ErrorTile` copies that had drifted apart
/// across the community screens.
///
/// Pass [error] as well as [message]: the raw error decides what the user
/// actually sees. A missing migration reads as "apply the pending migration"
/// rather than a generic failure, and hides the retry button, because retrying
/// a schema error can never succeed.
class CommunityErrorView extends StatelessWidget {
  const CommunityErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.error,
    this.compact = false,
    this.retryLabel = 'Try again',
  });

  final String message;
  final VoidCallback onRetry;
  final Object? error;

  /// Inline banner instead of a centred block - used inside carousels.
  final bool compact;
  final String retryLabel;

  String get _resolvedMessage =>
      describeCommunityError(error, fallback: message);

  bool get _retryable => !isSchemaMismatch(error);

  @override
  Widget build(BuildContext context) {
    final text = _resolvedMessage;

    if (compact) {
      return Container(
        padding: AppSpacing.all(AppSpacing.h16),
        decoration: BoxDecoration(
          color: AppColors.warning50,
          borderRadius: AppRadius.all03,
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.warning600),
            SizedBox(width: AppSpacing.h10),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.warning700),
              ),
            ),
            if (_retryable)
              TextButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _retryable ? Icons.wifi_off_rounded : Icons.storage_rounded,
            size: 48,
            color: AppColors.neutral400,
          ),
          SizedBox(height: AppSpacing.v12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          if (_retryable) ...[
            SizedBox(height: AppSpacing.v16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(retryLabel),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state, optionally with a call to action.
class CommunityEmptyView extends StatelessWidget {
  const CommunityEmptyView({
    super.key,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 44, color: AppColors.neutral300),
            SizedBox(height: AppSpacing.v12),
          ],
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: AppSpacing.v16),
            OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

/// Fixed-height centred spinner, so a loading list doesn't collapse the layout.
class CommunityLoadingView extends StatelessWidget {
  const CommunityLoadingView({super.key, this.height = 200});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Footer for an infinite list: spinner, retry, or "end of list".
class CommunityLoadMoreFooter extends StatelessWidget {
  const CommunityLoadMoreFooter({
    super.key,
    required this.isLoading,
    required this.hasMore,
    required this.onRetry,
    this.error,
    this.endLabel = "You're all caught up",
  });

  final bool isLoading;
  final bool hasMore;
  final VoidCallback onRetry;
  final Object? error;
  final String endLabel;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Could not load more. Tap to retry'),
          ),
        ),
      );
    }

    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (hasMore) return SizedBox(height: AppSpacing.v16);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v22),
      child: Center(
        child: Text(
          endLabel,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
        ),
      ),
    );
  }
}
