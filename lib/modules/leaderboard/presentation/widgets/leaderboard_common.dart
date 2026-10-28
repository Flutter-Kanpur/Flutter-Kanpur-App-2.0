import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:share_plus/share_plus.dart';

/// Back arrow + centered title, shared by Leaderboard and My Rank.
class RankingAppBar extends StatelessWidget {
  const RankingAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h8,
        vertical: AppSpacing.v8,
      ),
      child: Row(
        children: [
          const FkBackButton(fallbackPath: RouteNames.profile),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Balances the back button so the title is visually centered.
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// Outlined "Share with friends" pill. Opens the system share sheet.
class ShareWithFriendsButton extends StatelessWidget {
  const ShareWithFriendsButton({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => SharePlus.instance.share(ShareParams(text: message)),
      icon: const Icon(Icons.share_outlined, size: 18),
      label: Text('leaderboard.share'.tr()),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.blackBase,
        backgroundColor: AppColors.whiteBase,
        side: const BorderSide(color: AppColors.neutral200),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.all09),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v10,
        ),
        textStyle: AppTextStyles.bodyLarge,
      ),
    );
  }
}

/// "1 point" / "55 points".
String pointsLabel(int points) => 'leaderboard.points'.plural(points);
