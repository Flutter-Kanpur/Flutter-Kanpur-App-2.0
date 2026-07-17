import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';
import 'package:flutter_knp_mobile_app_v2/utils/text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../application/problem_of_day_provider.dart';
import '../../../application/problem_of_day_state.dart';

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
              color: AppColors.textBlack,
            ),
          ),
          title: Text('Problem of the Day', style: textStyle_18BoldBlack()),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroCard(problem: overview.problem, onSolve: () {}),
              SizedBox(height: 20.h),
              _ProgressCard(progress: overview.progress),
              SizedBox(height: 16.h),
              _StatsCard(progress: overview.progress),
              SizedBox(height: 20.h),
              Text('Details', style: textStyle_16RegularGrey()),
              SizedBox(height: 8.h),
              _DetailsCard(
                details: overview.details,
                progress: overview.progress,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Badges', style: textStyle_16RegularGrey()),
                  GestureDetector(
                    onTap: () {},
                    child: Text('View', style: textStyle_16BoldLinkBlue()),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _BadgeStack(badges: overview.badges),
              SizedBox(height: 16.h),
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
      borderRadius: BorderRadius.circular(28.r),
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/announcements_card_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  problem.title,
                  style: textStyle_18MediumBlack().copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  problem.description,
                  style: textStyle_16RegularBlack().copyWith(
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 20.h),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSolve,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Solve problem',
                        style: textStyle_16MediumBlack(),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // Mostly-white translucent glass — the page's own light-blue
        // GradientBackground tint shows through faintly instead of a
        // manually baked-in blue gradient.
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.communityBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: textStyle_16MediumBlack()),
              Text(
                '${progress.challengeDaysCompleted} / ${progress.challengeDaysGoal} days',
                style: textStyle_14RegularGrey(),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.challengeDaysGoal == 0
                  ? 0
                  : (progress.challengeDaysCompleted / progress.challengeDaysGoal)
                      .clamp(0.0, 1.0),
              backgroundColor: AppColors.bgPrimary,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
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
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.communityBorder),
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
        Text(value, style: textStyle_24BlackBold().copyWith(fontSize: 28.sp)),
        SizedBox(height: 4.h),
        Text(label, style: textStyle_14RegularGrey()),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.communityGuidelinesBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _DetailRow(label: 'Frequency', value: details.frequency),
          Divider(height: 1, color: AppColors.communityBorder),
          _DetailRow(label: 'Difficulty', value: details.difficulty),
          Divider(height: 1, color: AppColors.communityBorder),
          _DetailRow(label: 'Level', value: levelLabel),
          Divider(height: 1, color: AppColors.communityBorder),
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
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle_16MediumBlack()),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textStyle_16RegularGrey(),
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
      color: Colors.white,
      size: 26.sp,
    );

    return Container(
      width: 56.w,
      height: 56.w,
      padding: EdgeInsets.all(2.w),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badge.isUnlocked ? AppColors.primary : AppColors.textGray,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.yellowWarningBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: AppColors.amberText, size: 18.sp),
          SizedBox(width: 10.w),
          Text(
            'Next badge - $streakDaysThreshold days streak',
            style: textStyle_14YellowRegular(),
          ),
        ],
      ),
    );
  }
}
