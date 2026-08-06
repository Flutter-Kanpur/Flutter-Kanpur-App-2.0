import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommonSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onMicTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;

  const CommonSearchBar({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onMicTap,
    this.focusNode,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all07,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary500.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.h16,
            vertical: AppSpacing.v16,
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                size: 20.sp,
                color: AppColors.blackBase,
              ),
              12.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.blackBase,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        hintText ?? translate(context, 'common.searchEvents'),
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral500,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(
                color: AppColors.blackBase,
                width: AppSpacing.v2,
                height: 25,
              ),
              8.horizontalSpace,
              GestureDetector(
                onTap: onMicTap,
                child: Icon(
                  Icons.mic_none,
                  color: AppColors.blackBase,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
