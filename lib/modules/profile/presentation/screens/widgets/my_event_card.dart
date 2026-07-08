import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../application/my_events_provider.dart';
import '../../../application/my_events_state.dart';

/// Card for a single event on the My Events screen: status pill + bookmark,
/// title, date/location, a truncatable description, and a View Details CTA.
class MyEventCard extends ConsumerWidget {
  const MyEventCard({
    super.key,
    required this.event,
    required this.onToggleSaved,
    required this.onViewDetails,
  });

  final MyEvent event;
  final VoidCallback onToggleSaved;
  final VoidCallback onViewDetails;

  /// "Live" is the app's brand blue rather than a generic status color, so
  /// it's special-cased; everything else defers to AppColors.statusPair().
  Color _statusColor(String label) {
    if (label == 'Live') return AppColors.primary;
    return AppColors.statusPair(label).fg;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _statusColor(event.statusLabel);
    final expanded = ref.watch(myEventCardExpandedProvider(event.id));

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.communityBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(100),
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
                    SizedBox(width: 6.w),
                    Text(
                      event.statusLabel,
                      style: textStyle_14RegularBlack().copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onToggleSaved,
                icon: Icon(
                  event.isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: event.isSaved ? AppColors.primary : AppColors.textGray,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(event.title, style: textStyle_18BlackMedium()),
          SizedBox(height: 8.h),
          Text(
            event.dateTimeLocation,
            style: textStyle_14RegularBlack().copyWith(color: AppColors.green),
          ),
          SizedBox(height: 8.h),
          Text(
            event.description,
            maxLines: expanded ? null : 2,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: textStyle_13RegularGrey(),
          ),
          if (!expanded)
            GestureDetector(
              onTap: () =>
                  ref.read(myEventCardExpandedProvider(event.id).notifier).toggle(),
              child: Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: Text('see more', style: textStyle_14RegularLinkBlue()),
              ),
            ),
          SizedBox(height: 16.h),
          GradientButton(
            text: 'View Details',
            height: 48.h,
            onTap: onViewDetails,
            textStyle: textStyle_14SemiBoldWhite(),
          ),
        ],
      ),
    );
  }
}
