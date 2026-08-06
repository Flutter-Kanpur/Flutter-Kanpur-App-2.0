import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class FkConfirmDialog extends StatelessWidget {
  const FkConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.onCancel,
    this.confirmColor = AppColors.warning600,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    String cancelLabel = 'Cancel',
    Color confirmColor = AppColors.warning600,
    bool barrierDismissible = false,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => FkConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        onConfirm: () {
          Navigator.of(ctx).pop();
          onConfirm();
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteBase,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all07),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v18,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w700,
              ),
            ),
            12.verticalSpace,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            24.verticalSpace,
            GradientButton(
              color: confirmColor,
              onTap: onConfirm,
              text: confirmLabel,
              height: 48.h,
              width: double.infinity,
            ),
            14.verticalSpace,
            GestureDetector(
              onTap: onCancel ?? () => Navigator.of(context).pop(),
              child: Text(
                cancelLabel,
                style: AppTextStyles.bodyLarge.copyWith(color: confirmColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
