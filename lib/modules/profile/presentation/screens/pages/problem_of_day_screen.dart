import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../application/problem_of_day_provider.dart';
import '../../../application/problem_of_day_state.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class ProblemOfDayScreen extends ConsumerWidget {
  const ProblemOfDayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overview = ref.watch(problemOfDayProvider);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(
              Icons.arrow_back,
              size: 22.sp,
              color: AppColors.blackBase,
            ),
          ),
          title: Text(
            'Problem of the Day',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.blackBase,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.h20,
            AppSpacing.h8,
            AppSpacing.h20,
            AppSpacing.h22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroCard(problem: overview.problem, onSolve: () {}),
              SizedBox(height: AppSpacing.v20),
              _ProgressCard(progress: overview.progress),
              SizedBox(height: AppSpacing.v16),
              _StatsCard(progress: overview.progress),
              SizedBox(height: AppSpacing.v20),
              Text(
                'Details',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
              SizedBox(height: AppSpacing.v8),
              _DetailsCard(
                details: overview.details,
                progress: overview.progress,
              ),
              SizedBox(height: AppSpacing.v22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Badges',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'View',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.v12),
              _BadgeStack(badges: overview.badges),
              SizedBox(height: AppSpacing.v16),
              _NextBadgeNotice(
                streakDaysThreshold: overview.nextBadgeStreakThreshold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.problem, required this.onSolve});

  final DailyProblem problem;
  final VoidCallback onSolve;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.all06,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/announcements_card_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: AppSpacing.all(AppSpacing.h20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  problem.title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.whiteBase,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.v12),
                Text(
                  problem.description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.whiteBase,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: AppSpacing.v20),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSolve,
                    borderRadius: AppRadius.all09,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.h22,
                        vertical: AppSpacing.v12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteBase,
                        borderRadius: AppRadius.all09,
                      ),
                      child: Text(
                        'Solve problem',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.blackBase,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress});

  final ProblemStreakProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.all(AppSpacing.h16),
      decoration: BoxDecoration(
        // Mostly-white translucent glass — the page's own light-blue
        // GradientBackground tint shows through faintly instead of a
        // manually baked-in blue gradient.
        color: AppColors.whiteBase.withValues(alpha: 0.7),
        borderRadius: AppRadius.all05,
        border: Border.all(color: AppBorders.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.blackBase,
                ),
              ),
              Text(
                '${progress.challengeDaysCompleted} / ${progress.challengeDaysGoal} days',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.v12),
          ClipRRect(
            borderRadius: AppRadius.all09,
            child: LinearProgressIndicator(
              value: progress.challengeDaysGoal == 0
                  ? 0
                  : (progress.challengeDaysCompleted /
                            progress.challengeDaysGoal)
                        .clamp(0.0, 1.0),
              backgroundColor: AppColors.neutral50,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary500,
              ),
              minHeight: 8.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.progress});

  final ProblemStreakProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v20),
      decoration: BoxDecoration(
        color: AppColors.whiteBase.withValues(alpha: 0.7),
        borderRadius: AppRadius.all05,
        border: Border.all(color: AppBorders.primary),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              value: progress.currentStreakDays.toString().padLeft(2, '0'),
              label: 'Days streak',
            ),
          ),
          Expanded(
            child: _StatColumn(
              value: progress.totalProblemsSolved.toString(),
              label: 'Problems solved',
            ),
          ),
          Expanded(
            child: _StatColumn(
              value: '${(progress.levelProgress * 100).round()}%',
              label: 'Level progress',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.blackBase,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.v4),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.details, required this.progress});

  final ProblemOfDayDetails details;
  final ProblemStreakProgress progress;

  @override
  Widget build(BuildContext context) {
    final startedOn = details.startedOn;
    final startedOnLabel =
        '${startedOn.shortMonth} ${startedOn.day}, ${startedOn.year}';
    final levelLabel =
        'Level ${progress.currentLevel} — ${progress.currentLevelName}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: AppRadius.all05,
      ),
      child: Column(
        children: [
          _DetailRow(label: 'Frequency', value: details.frequency),
          Divider(height: 1, color: AppBorders.primary),
          _DetailRow(label: 'Difficulty', value: details.difficulty),
          Divider(height: 1, color: AppBorders.primary),
          _DetailRow(label: 'Level', value: levelLabel),
          Divider(height: 1, color: AppBorders.primary),
          _DetailRow(label: 'Started On', value: startedOnLabel),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.v16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.blackBase,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badges overlap like an avatar stack (leftmost fully visible, each
/// following one tucked partly behind it) rather than sitting apart with
/// gaps between them.
class _BadgeStack extends StatelessWidget {
  const _BadgeStack({required this.badges});

  final List<ProblemBadge> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 56.h,
      width: (56 + (badges.length - 1) * 34).w,
      child: Stack(
        children: List.generate(badges.length, (index) {
          final reverseIndex = badges.length - 1 - index;
          return Positioned(
            left: (reverseIndex * 34).w,
            child: _BadgeIcon(badge: badges[reverseIndex]),
          );
        }),
      ),
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  const _BadgeIcon({required this.badge});

  final ProblemBadge badge;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(
      Icons.military_tech_rounded,
      color: AppColors.whiteBase,
      size: 26.sp,
    );

    return Container(
      width: 56.w,
      height: 56.w,
      padding: AppSpacing.all(AppSpacing.h2),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.whiteBase,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badge.isUnlocked ? AppColors.primary500 : AppColors.neutral500,
        ),
        child: badge.iconUrl.isEmpty
            ? Center(child: placeholder)
            : ClipOval(
                child: CachedNetworkImage(
                  imageUrl: badge.iconUrl,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Center(child: placeholder),
                ),
              ),
      ),
    );
  }
}

class _NextBadgeNotice extends StatelessWidget {
  const _NextBadgeNotice({required this.streakDaysThreshold});

  final int streakDaysThreshold;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v16,
      ),
      decoration: BoxDecoration(
        color: AppColors.pending50,
        borderRadius: AppRadius.all04,
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: AppColors.pending600, size: 18.sp),
          SizedBox(width: AppSpacing.h10),
          Text(
            'Next badge - $streakDaysThreshold days streak',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.pending600,
            ),
          ),
        ],
      ),
    );
  }
}
