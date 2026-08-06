import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

/// Centred screen title with a back arrow and an optional trailing action.
///
/// Replaces the near-identical private `_TopBar` that had been copied into
/// each community screen. The arrow is [AppColors.neutral950] per the design —
/// the old copies inherited a grey icon colour from the theme.
class FkScreenTopBar extends StatelessWidget {
  const FkScreenTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.fallbackPath,
    this.trailing,
  });

  final String title;

  /// Defaults to popping the route, falling back to [fallbackPath].
  final VoidCallback? onBack;
  final String? fallbackPath;
  final Widget? trailing;

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else if (fallbackPath != null) {
      context.go(fallbackPath!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => _handleBack(context),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.neutral950,
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral950,
            ),
          ),
        ),
        // Keeps the title optically centred when there is no trailing action.
        trailing ?? SizedBox(width: AppSpacing.h22 * 2),
      ],
    );
  }
}
