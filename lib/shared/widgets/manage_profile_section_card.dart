import 'package:flutter/material.dart';
import '../../../utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';

class ManageProfileSectionCard extends StatelessWidget {
  const ManageProfileSectionCard({
    super.key,
    required this.title,
    this.value,
    this.tags,
    this.child,
    this.onEdit,
  });

  final String title;
  final String? value;
  final List<String>? tags;
  final Widget? child;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyle_16BoldBlack().copyWith(fontSize: 16.sp),
        ),
        if (value != null) ...[
          SizedBox(height: 8.h),
          Text(
            value!,
            style: textStyle_16RegularBlack().copyWith(
              color: AppColors.subtitleTextDarkGrey,
              fontSize: 14.sp,
            ),
          ),
        ],
        if (child != null) ...[
          SizedBox(height: 8.h),
          child!,
        ],
        if (tags != null && tags!.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: tags!.map((t) => _SectionPill(label: t)).toList(),
          ),
        ],
        if (onEdit != null) ...[
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onEdit,
            child: Text(
              translate(context, "profile.edit"),
              style: textStyle_14RegularBlack().copyWith(
                color: AppColors.selectedNavBarIconColor,
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionPill extends StatelessWidget {
  const _SectionPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.communityBorderColorV2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: textStyle_14RegularBlack().copyWith(
          color: const Color(0xFF3D3D3D),
        ),
      ),
    );
  }
}
