import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/application/leaderboard_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_error_view.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/leaderboard_common.dart';

/// "My Ranks": the user's level (from their latest leaderboard points),
/// progress to the next level and their leaderboard position.
class MyRankScreen extends ConsumerWidget {
  const MyRankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankAsync = ref.watch(myRankProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              RankingAppBar(title: 'myRank.title'.tr()),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.refresh(myRankProvider.future),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: rankAsync.when(
                          skipLoadingOnRefresh: !rankAsync.hasError,
                          loading: () => const _MyRankSkeleton(),
                          error: (_, _) => Center(
                            child: FkErrorView(
                              message: 'myRank.loadError'.tr(),
                              onRetry: () => ref.invalidate(myRankProvider),
                            ),
                          ),
                          data: (rank) => _MyRankBody(rank: rank),
                        ),
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
}

class _MyRankBody extends StatelessWidget {
  const _MyRankBody({required this.rank});

  final MyRank rank;

  @override
  Widget build(BuildContext context) {
    final level = rank.level;
    final levelTitle = level.titleKey.tr();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h20,
        AppSpacing.v22,
        AppSpacing.h20,
        AppSpacing.v22,
      ),
      child: Column(
        children: [
          _RankMedal(level: level.level),
          SizedBox(height: AppSpacing.v22),
          Text(
            levelTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          Text(
            'myRank.levelOf'.tr(args: ['${level.level}', '${RankLevel.count}']),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary500,
            ),
          ),
          SizedBox(height: AppSpacing.v12),
          Text(
            'myRank.description'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.neutral500,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSpacing.v22),
          _ProgressCard(rank: rank),
          SizedBox(height: AppSpacing.v22),
          ShareWithFriendsButton(
            message: 'myRank.shareMessage'.tr(
              args: [levelTitle, '${level.level}', '${RankLevel.count}'],
            ),
          ),
          SizedBox(height: AppSpacing.v8),
          TextButton(
            onPressed: () => context.push(RouteNames.leaderboard),
            child: Text('myRank.viewLeaderboard'.tr()),
          ),
        ],
      ),
    );
  }
}

/// Points, leaderboard position and the bar toward the next level.
class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.rank});

  final MyRank rank;

  @override
  Widget build(BuildContext context) {
    final next = rank.level.next;
    final String status;
    if (!rank.hasLeaderboard) {
      status = 'myRank.notPublished'.tr();
    } else if (!rank.isRanked) {
      status = 'myRank.notRanked'.tr();
    } else if (next == null) {
      status = 'myRank.topLevel'.tr();
    } else {
      status = 'myRank.toNext'.tr(
        args: [pointsLabel(rank.pointsToNext), next.titleKey.tr()],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.h16),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all05,
        border: Border.all(color: AppColors.primary100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pointsLabel(rank.points),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.blackBase,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (rank.isRanked)
                Text(
                  'myRank.position'.tr(args: ['${rank.rank}']),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          ClipRRect(
            borderRadius: AppRadius.all09,
            child: LinearProgressIndicator(
              value: rank.progressToNext,
              minHeight: 8.r,
              backgroundColor: AppColors.primary100,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary500),
            ),
          ),
          SizedBox(height: AppSpacing.v10),
          Text(
            status,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ribbon medal with a star, drawn in Flutter (no image asset needed).
class _RankMedal extends StatelessWidget {
  const _RankMedal({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final size = 132.r;
    Widget ribbon(double angle, Alignment alignment) => Align(
      alignment: alignment,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: size * 0.26,
          height: size * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(size * 0.04),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary600, AppColors.primary400],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      label: 'myRank.levelOf'.tr(args: ['$level', '${RankLevel.count}']),
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size * 1.25,
        child: Stack(
          children: [
            ribbon(0.35, const Alignment(-0.35, 1)),
            ribbon(-0.35, const Alignment(0.35, 1)),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: size * 0.82,
                height: size * 0.82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.whiteBase, AppColors.neutral200],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary500.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Container(
                  width: size * 0.6,
                  height: size * 0.6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary50,
                  ),
                  child: Icon(
                    Icons.star_rounded,
                    size: size * 0.45,
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyRankSkeleton extends StatelessWidget {
  const _MyRankSkeleton();

  @override
  Widget build(BuildContext context) {
    return FkSkeletonPulse(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.h22),
        child: Column(
          children: [
            FkSkeletonBlock(width: 120.r, height: 120.r, radius: 60.r),
            SizedBox(height: AppSpacing.v22),
            FkSkeletonBlock(width: 200.r, height: 24.r, radius: AppRadius.r02),
            SizedBox(height: AppSpacing.v12),
            FkSkeletonBlock(width: 110.r, height: 18.r, radius: AppRadius.r02),
            SizedBox(height: AppSpacing.v22),
            FkSkeletonBlock(height: 96.r, radius: AppRadius.r05),
          ],
        ),
      ),
    );
  }
}
