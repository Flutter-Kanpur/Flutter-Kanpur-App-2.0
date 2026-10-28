import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/application/badges_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_dashed_divider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_error_view.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/badge_card.dart';
import '../widgets/badge_detail_dialog.dart';

/// "Your Badges": badges grouped by category with earned/total counts.
/// Tapping a badge opens [showBadgeDetailDialog].
class YourBadgesScreen extends ConsumerWidget {
  const YourBadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(myBadgeCategoriesProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const _BadgesAppBar(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () =>
                      ref.refresh(myBadgeCategoriesProvider.future),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.h20,
                          AppSpacing.v8,
                          AppSpacing.h20,
                          AppSpacing.v12,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'badges.intro'.tr(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.neutral700,
                            ),
                          ),
                        ),
                      ),
                      ...categoriesAsync.when(
                        // Keep the grid during pull-to-refresh, but show the
                        // skeleton when retrying from the error view.
                        skipLoadingOnRefresh: !categoriesAsync.hasError,
                        loading: () => const [
                          SliverToBoxAdapter(child: _BadgesSkeleton()),
                        ],
                        error: (_, _) => [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: FkErrorView(
                                message: 'badges.loadError'.tr(),
                                onRetry: () =>
                                    ref.invalidate(myBadgeCategoriesProvider),
                              ),
                            ),
                          ),
                        ],
                        data: (categories) => categories.isEmpty
                            ? const [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _EmptyBadgesView(),
                                ),
                              ]
                            : [
                                for (final category in categories)
                                  ..._categorySlivers(context, category),
                              ],
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.v22),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _categorySlivers(BuildContext context, BadgeCategory category) {
    return [
      SliverToBoxAdapter(child: _CategoryHeader(category: category)),
      SliverPadding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.h20,
          AppSpacing.v16,
          AppSpacing.h20,
          AppSpacing.v22,
        ),
        sliver: SliverGrid(
          gridDelegate: _gridDelegate,
          delegate: SliverChildBuilderDelegate((context, index) {
            final badge = category.badges[index];
            return BadgeCard(
              badge: badge,
              onTap: () => showBadgeDetailDialog(context, badge),
            );
          }, childCount: category.badges.length),
        ),
      ),
    ];
  }
}

SliverGridDelegateWithFixedCrossAxisCount get _gridDelegate =>
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.v16,
      crossAxisSpacing: AppSpacing.h16,
      // Fixed height fits art + a two-line title + subtitle at any width.
      mainAxisExtent: 176.r,
    );

class _BadgesAppBar extends StatelessWidget {
  const _BadgesAppBar();

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
              'profile.yourBadges'.tr(),
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

/// "Daily Practice ........ 2/5" with the dashed rule under it.
class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});

  final BadgeCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontal(AppSpacing.h20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category.name,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.neutral900,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.h8),
              Text(
                '${category.earnedCount}/${category.totalCount}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          const FkDashedDivider(),
        ],
      ),
    );
  }
}

class _EmptyBadgesView extends StatelessWidget {
  const _EmptyBadgesView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.horizontal(AppSpacing.h22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.workspace_premium_outlined,
              size: 56.r,
              color: AppColors.primary300,
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              'badges.emptyTitle'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.v8),
            Text(
              'badges.emptyMessage'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Two category headers with a 2x2 grid each, pulsing while loading.
class _BadgesSkeleton extends StatelessWidget {
  const _BadgesSkeleton();

  @override
  Widget build(BuildContext context) {
    return FkSkeletonPulse(
      child: Padding(
        padding: AppSpacing.horizontal(AppSpacing.h20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var section = 0; section < 2; section++) ...[
              FkSkeletonBlock(
                width: 140.r,
                height: 18.r,
                radius: AppRadius.r02,
              ),
              SizedBox(height: AppSpacing.v12),
              const FkDashedDivider(),
              SizedBox(height: AppSpacing.v16),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: _gridDelegate,
                children: [
                  for (var i = 0; i < 4; i++)
                    FkSkeletonBlock(height: 176.r, radius: AppRadius.r04),
                ],
              ),
              SizedBox(height: AppSpacing.v22),
            ],
          ],
        ),
      ),
    );
  }
}
