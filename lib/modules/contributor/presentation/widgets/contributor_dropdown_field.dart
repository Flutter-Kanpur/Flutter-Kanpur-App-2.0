import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

class ContributorDropdownField extends StatelessWidget {
  const ContributorDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint = "-select-",
    this.validator,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hint;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: AppSpacing.v10),

        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: AppColors.whiteBase,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          hint: Text(
            hint,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral300,
            ),
          ),

          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteBase,

            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.h16,
              vertical: AppSpacing.v18,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide(color: AppBorders.primary),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide(color: AppBorders.blue, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: BorderSide(color: AppBorders.blue),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.all03,
              borderSide: const BorderSide(
                color: AppColors.warning600,
                width: 1.5,
              ),
            ),
          ),

          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: theme.textTheme.bodyMedium),
                ),
              )
              .toList(),

          onChanged: onChanged,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.neutral400,
          ),
        ),
      ],
    );
  }
}
