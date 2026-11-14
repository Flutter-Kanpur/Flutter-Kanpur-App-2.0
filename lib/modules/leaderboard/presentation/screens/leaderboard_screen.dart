import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/application/leaderboard_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_dashed_divider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_error_view.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_block.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_skeleton_pulse.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/leaderboard_common.dart';

/// Latest community leaderboard: top 3 as balloons, everyone else in a list.
/// The signed-in user's row is highlighted. Rows load page by page as the
/// user nears the bottom (infinite scroll).
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  /// Start fetching the next page this far (px) from the bottom, same
  /// threshold as the Community Discussions feed.
  static const _loadMoreThreshold = 400.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final myId = ref.watch(currentUserIdProvider).value;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              RankingAppBar(title: 'profile.leaderboard'.tr()),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => ref.refresh(leaderboardProvider.future),
                  // A listener instead of a ScrollController so the screen
                  // stays a ConsumerWidget (no StatefulWidget). Only
                  // user/fling scroll updates trigger it - never mid-build.
                  // loadMore() itself ignores repeat calls.
                  child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (n) {
                      if (n.metrics.axis == Axis.vertical &&
                          n.metrics.extentAfter < _loadMoreThreshold) {
                        ref.read(leaderboardProvider.notifier).loadMore();
                      }
                      // Let RefreshIndicator see the notification too.
                      return false;
                    },
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        leaderboardAsync.when(
                          // Keep the board during pull-to-refresh, but show
                          // the skeleton when retrying from the error view.
                          skipLoadingOnRefresh: !leaderboardAsync.hasError,
                          loading: () => const SliverToBoxAdapter(
                            child: _LeaderboardSkeleton(),
                          ),
                          error: (_, _) => SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: FkErrorView(
                                message: 'leaderboard.loadError'.tr(),
                                onRetry: () =>
                                    ref.invalidate(leaderboardProvider),
                              ),
                            ),
                          ),
                          data: (board) => board.isEmpty
                              ? const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _EmptyLeaderboardView(),
                                )
                              : _LeaderboardBody(
                                  board: board,
                                  myId: myId,
                                  onRetryLoadMore: () => ref
                                      .read(leaderboardProvider.notifier)
                                      .loadMore(),
                                ),
                        ),
                      ],
                    ),
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

/// The loaded board as slivers, so rank rows are built lazily as they
/// scroll into view instead of all at once.
class _LeaderboardBody extends StatelessWidget {
  const _LeaderboardBody({
    required this.board,
    required this.myId,
    required this.onRetryLoadMore,
  });

  final Leaderboard board;
  final String? myId;
  final VoidCallback onRetryLoadMore;

  /// Uses the ranked message only once the user's row has been loaded.
  String get _shareMessage {
    final me = board.entries.where((e) => e.userId == myId).firstOrNull;
    return me == null
        ? 'leaderboard.shareMessage'.tr()
        : 'leaderboard.shareMessageRanked'.tr(
            args: ['${me.rank}', pointsLabel(me.points)],
          );
  }

  @override
  Widget build(BuildContext context) {
    final rest = board.rest;
    final loadMoreError = board.loadMoreError;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.h20,
        AppSpacing.v8,
        AppSpacing.h20,
        AppSpacing.v22,
      ),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: _Podium(entries: board.podium, myId: myId),
          ),
          if (rest.isNotEmpty)
            _RankListSliver(entries: rest, myId: myId)
          else
            const SliverToBoxAdapter(child: FkDashedDivider()),
          // Footer: next page in flight, or it failed (loaded rows stay).
          if (board.isLoadingMore)
            SliverPadding(
              padding: EdgeInsets.only(top: AppSpacing.v10),
              sliver: const SliverToBoxAdapter(
                child: FkSkeletonPulse(child: _RankRowsSkeleton(count: 2)),
              ),
            )
          else if (loadMoreError != null)
            SliverToBoxAdapter(
              child: FkErrorView(
                message: 'leaderboard.loadMoreError'.tr(),
                onRetry: onRetryLoadMore,
              ),
            ),
          // Shown only after the last page so it doesn't jump down each
          // time another page is appended below it.
          if (!board.hasMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.v22),
                child: Center(
                  child: ShareWithFriendsButton(message: _shareMessage),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Ranks 1-3 as balloons on strings: 1st in the middle (largest),
/// 2nd on the left, 3rd on the right - as in the design.
class _Podium extends StatelessWidget {
  const _Podium({required this.entries, required this.myId});

  final List<LeaderboardEntry> entries;
  final String? myId;

  @override
  Widget build(BuildContext context) {
    LeaderboardEntry? at(int rankIndex) =>
        rankIndex < entries.length ? entries[rankIndex] : null;

    return SizedBox(
      height: 230.r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Balloon(
            entry: at(1),
            color: AppColors.primary500,
            size: 84.r,
            topOffset: 48.r,
            isMe: at(1)?.userId == myId,
          ),
          _Balloon(
            entry: at(0),
            color: AppColors.pending400,
            size: 104.r,
            topOffset: 0,
            isMe: at(0)?.userId == myId,
          ),
          _Balloon(
            entry: at(2),
            color: AppColors.warning600,
            size: 72.r,
            topOffset: 64.r,
            isMe: at(2)?.userId == myId,
          ),
        ],
      ),
    );
  }
}

class _Balloon extends StatelessWidget {
  const _Balloon({
    required this.entry,
    required this.color,
    required this.size,
    required this.topOffset,
    required this.isMe,
  });

  final LeaderboardEntry? entry;
  final Color color;
  final double size;
  final double topOffset;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final entry = this.entry;
    if (entry == null) return const Expanded(child: SizedBox.shrink());

    return Expanded(
      child: Semantics(
        label: 'leaderboard.rankSemantics'.tr(
          args: ['${entry.rank}', entry.name, pointsLabel(entry.points)],
        ),
        excludeSemantics: true,
        child: Column(
          children: [
            SizedBox(height: topOffset),
            Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(size * 0.1),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isMe
                    ? Border.all(color: AppColors.whiteBase, width: 3)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: size * 0.8),
                      child: Text(
                        entry.shortName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.whiteBase,
                        ),
                      ),
                    ),
                    Text(
                      '${entry.points}',
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.whiteBase,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            // The balloon's string, running down to the list card.
            Expanded(child: Container(width: 1.5, color: AppColors.neutral700)),
          ],
        ),
      ),
    );
  }
}

/// Rank 4+ in a rounded card with dashed separators. A sliver (not a
/// Column) so only on-screen rows are built as pages keep appending.
class _RankListSliver extends StatelessWidget {
  const _RankListSliver({required this.entries, required this.myId});

  final List<LeaderboardEntry> entries;
  final String? myId;

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all05,
        border: Border.all(color: AppColors.primary100),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary500.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      sliver: SliverPadding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.v6),
        sliver: SliverList.separated(
          itemCount: entries.length,
          itemBuilder: (context, i) =>
              _RankRow(entry: entries[i], isMe: entries[i].userId == myId),
          separatorBuilder: (context, _) => Padding(
            padding: AppSpacing.horizontal(AppSpacing.h16),
            child: const FkDashedDivider(),
          ),
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.entry, required this.isMe});

  final LeaderboardEntry entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final name = isMe ? 'leaderboard.you'.tr(args: [entry.name]) : entry.name;

    return Container(
      color: isMe ? AppColors.primary50 : null,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v12,
      ),
      child: Row(
        children: [
          Container(
            width: 34.r,
            height: 34.r,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  '${entry.rank}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.blackBase,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.h12),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primary500,
                fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.h8),
          Text(
            pointsLabel(entry.points),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase),
          ),
        ],
      ),
    );
  }
}

class _EmptyLeaderboardView extends StatelessWidget {
  const _EmptyLeaderboardView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.horizontal(AppSpacing.h22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.leaderboard_outlined,
              size: 56.r,
              color: AppColors.primary300,
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              'leaderboard.emptyTitle'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.v8),
            Text(
              'leaderboard.emptyMessage'.tr(),
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

class _LeaderboardSkeleton extends StatelessWidget {
  const _LeaderboardSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget circle(double size, double top) => Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: Align(
          alignment: Alignment.topCenter,
          child: FkSkeletonBlock(width: size, height: size, radius: size / 2),
        ),
      ),
    );

    return FkSkeletonPulse(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.h20,
          AppSpacing.v8,
          AppSpacing.h20,
          AppSpacing.v22,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 200.r,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  circle(84.r, 48.r),
                  circle(104.r, 0),
                  circle(72.r, 64.r),
                ],
              ),
            ),
            const _RankRowsSkeleton(count: 6),
          ],
        ),
      ),
    );
  }
}

/// Placeholder rank rows: the first-load skeleton's list part, and the
/// infinite-scroll footer while the next page loads. Callers wrap it in
/// [FkSkeletonPulse].
class _RankRowsSkeleton extends StatelessWidget {
  const _RankRowsSkeleton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          FkSkeletonBlock(height: 44.r, radius: AppRadius.r03),
          SizedBox(height: AppSpacing.v10),
        ],
      ],
    );
  }
}
