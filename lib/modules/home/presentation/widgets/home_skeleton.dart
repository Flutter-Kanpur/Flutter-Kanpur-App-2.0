import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/event_card_skeleton.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/filter_tabs_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterTabsSkeleton(),

        SizedBox(height: AppSpacing.v20),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
          child: Column(
            children: [
              const EventCardSkeleton(),

              SizedBox(height: 16.h),

              const EventCardSkeleton(),
            ],
          ),
        ),
      ],
    );
  }
}
