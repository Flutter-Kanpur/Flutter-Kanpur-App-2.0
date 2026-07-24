import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/my_events_provider.dart';
import '../../../application/my_events_state.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

/// Card for a single event on the My Events screen: status pill + bookmark,
/// title, date/location, a truncatable description, and a CTA row.
///
/// A past/completed event drops the bookmark (nothing to save for later),
/// swaps the CTA to "Give feedback", and adds a trailing eye/preview icon
/// button — mirrors modules/home/presentation/widgets/event_card_component.dart's
/// existing button+eye-icon layout for its own past-event case.
class MyEventCard extends ConsumerWidget {
  const MyEventCard({
    super.key,
    required this.event,
    required this.onToggleSaved,
    required this.onViewDetails,
    required this.onPreview,
  });

  final MyEvent event;
  final VoidCallback onToggleSaved;
  final VoidCallback onViewDetails;
  final VoidCallback onPreview;

  /// Status colors mapped to design-system tokens.
  Color _statusColor(String label) {
    return switch (label) {
      'Live' => AppColors.primary500,
      'Upcoming' => AppColors.pending400,
      'Ongoing' => AppColors.success600,
      'Missed' || 'Cancelled' => AppColors.warning600,
      _ => AppColors.neutral500,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(event.statusLabel);
    final expanded = ref.watch(myEventCardExpandedProvider(event.id));
    final isPast = event.category == MyEventCategory.past;

    return Container(
      padding: AppSpacing.all07,
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all05,
        border: Border.all(color: AppBorders.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s03),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: AppRadius.all09,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: AppSpacing.s03),
                    Text(
                      event.statusLabel,
                      style: AppTextStyles.bodyMedium.copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
              if (!isPast)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onToggleSaved,
                  icon: Icon(
                    event.isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: event.isSaved
                        ? AppColors.primary500
                        : AppColors.neutral500,
                    size: 24.sp,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.s06),
          Text(event.title, style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500)),
          SizedBox(height: AppSpacing.s04),
          Text(
            event.dateTimeLocation,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success600),
          ),
          SizedBox(height: AppSpacing.s04),
          Text(
            event.description,
            maxLines: expanded ? null : 2,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
          ),
          if (!expanded)
            GestureDetector(
              onTap: () => ref
                  .read(myEventCardExpandedProvider(event.id).notifier)
                  .toggle(),
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.s01),
                child: Text('see more', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary500)),
              ),
            ),
          SizedBox(height: AppSpacing.s07),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: isPast ? 'Give feedback' : 'View Details',
                  height: 48.h,
                  onTap: onViewDetails,
                  textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.whiteBase, fontWeight: FontWeight.w600),
                ),
              ),
              if (isPast) ...[
                SizedBox(width: AppSpacing.s06),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPreview,
                    borderRadius: AppRadius.all09,
                    child: Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppBorders.primary,
                        ),
                        borderRadius: AppRadius.all09,
                      ),
                      child: Icon(
                        Icons.visibility_outlined,
                        size: 20.sp,
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
