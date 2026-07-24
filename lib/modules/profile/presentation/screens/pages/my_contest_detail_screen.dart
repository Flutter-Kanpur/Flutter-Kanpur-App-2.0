import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../application/my_contests_provider.dart';
import '../../../application/my_contests_state.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

void _shareContest(MyContest contest) {
  final message = [
    contest.title,
    contest.categoryLabel,
    contest.scheduleLabel,
    '${contest.metaLabel} ${contest.metaValue}',
    contest.tags.join(' • '),
  ].join('\n');

  SharePlus.instance.share(ShareParams(text: message, subject: contest.title));
}

void _addToCalendar(MyContest contest) {
  final event = Event(
    title: contest.title,
    description: [contest.categoryLabel, ...contest.whatYoullDo].join('\n'),
    location: contest.tags.contains('Online') ? 'Online' : '',
    startDate: contest.startDate,
    endDate: contest.endDate,
  );
  Add2Calendar.addEvent2Cal(event);
}

class MyContestDetailScreen extends ConsumerWidget {
  const MyContestDetailScreen({super.key, required this.contestId});

  final String contestId;

  TextStyle _metaValueStyle(MyContestMetaTone tone) {
    return switch (tone) {
      MyContestMetaTone.urgent => AppTextStyles.bodyLarge.copyWith(color: AppColors.warning600),
      MyContestMetaTone.positive =>
        AppTextStyles.bodyLarge.copyWith(color: AppColors.success600),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contest = ref.watch(myContestByIdProvider(contestId));

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
          title: Text('Contest details', style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500)),
        ),
        body: contest == null
            ? Center(
                child: Text(
                  'Contest not found.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(AppSpacing.s09, AppSpacing.s04, AppSpacing.s09, AppSpacing.s10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contest.title, style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold)),
                    SizedBox(height: AppSpacing.s02),
                    Text(
                      contest.categoryLabel,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                    ),
                    SizedBox(height: AppSpacing.s07),
                    Row(
                      children: [
                        _OutlinedPillButton(
                          icon: Icons.share_outlined,
                          label: 'Share',
                          onTap: () => _shareContest(contest),
                        ),
                        SizedBox(width: AppSpacing.s06),
                        _OutlinedPillButton(
                          icon: contest.isSaved
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: contest.isSaved ? 'Saved' : 'Save',
                          onTap: () => ref
                              .read(myContestsProvider.notifier)
                              .toggleSaved(contest.id),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.s07),
                    Text(
                      contest.scheduleLabel,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase),
                    ),
                    SizedBox(height: AppSpacing.s02),
                    Text(
                      '${contest.metaLabel} ${contest.metaValue}',
                      style: _metaValueStyle(contest.metaTone),
                    ),
                    SizedBox(height: AppSpacing.s07),
                    Wrap(
                      spacing: AppSpacing.s04,
                      runSpacing: AppSpacing.s04,
                      children: contest.tags
                          .map(
                            (tag) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.s07,
                                vertical: AppSpacing.s04,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.neutral50,
                                borderRadius: AppRadius.all09,
                              ),
                              child: Text(
                                tag,
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: AppSpacing.s09),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppBorders.primary,
                    ),
                    SizedBox(height: AppSpacing.s09),
                    Text('What You\'ll Do', style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500)),
                    SizedBox(height: AppSpacing.s06),
                    _BulletList(items: contest.whatYoullDo),
                    SizedBox(height: AppSpacing.s09),
                    Text(
                      'Rewards & Outcomes',
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: AppSpacing.s06),
                    _BulletList(items: contest.rewardsAndOutcomes),
                    SizedBox(height: AppSpacing.s10),
                    GradientButton(
                      text: 'Add to Calendar',
                      height: 48.h,
                      onTap: () => _addToCalendar(contest),
                      textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.whiteBase, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  const _OutlinedPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.all09,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s08, vertical: AppSpacing.s05),
          decoration: BoxDecoration(
            color: AppColors.whiteBase,
            borderRadius: AppRadius.all09,
            border: Border.all(color: AppBorders.primary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.sp, color: AppColors.blackBase),
              SizedBox(width: AppSpacing.s03),
              Text(label, style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.s05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500)),
                  Expanded(child: Text(item, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500))),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
