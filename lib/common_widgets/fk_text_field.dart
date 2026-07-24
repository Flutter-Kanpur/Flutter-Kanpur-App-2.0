import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class FkTextField extends StatelessWidget {
  const FkTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.focused = false,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.s05),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.whiteBase,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.s07,
              vertical: AppSpacing.s07,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide(color: AppBorders.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: const BorderSide(color: AppBorders.blue),
            ),
          ),
        ),
      ],
    );
  }
}
