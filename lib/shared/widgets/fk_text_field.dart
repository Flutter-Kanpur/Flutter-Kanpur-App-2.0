import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

/// Labelled text input used across the app's forms.
///
/// Pass [maxLength] to hard-cap input; typing past the cap is blocked rather
/// than merely flagged, and an `n/max` counter renders under the field unless
/// [showCounter] is false.
class FkTextField extends StatelessWidget {
  const FkTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.focused = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.maxLength,
    this.showCounter = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.suffix,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final bool focused;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

  /// Hard character cap. Also drives the counter.
  final int? maxLength;
  final bool showCounter;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: autovalidateMode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      enabled: enabled,
      inputFormatters: [
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
      ],
      // The built-in counter is suppressed so the custom one below can sit
      // outside the decoration and stay aligned with the rest of the form.
      buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
          null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: enabled ? AppColors.whiteBase : AppColors.neutral50,
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.all03,
          borderSide: const BorderSide(color: AppBorders.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.all03,
          borderSide: const BorderSide(color: AppBorders.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.all03,
          borderSide: const BorderSide(color: AppColors.warning600),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.all03,
          borderSide: const BorderSide(color: AppColors.warning600),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.v10),
        ],
        field,
        if (maxLength != null && showCounter && controller != null)
          _CharCounter(controller: controller!, maxLength: maxLength!),
      ],
    );
  }
}

/// Live `n/max` counter that turns amber as the user approaches the cap.
class _CharCounter extends StatelessWidget {
  const _CharCounter({required this.controller, required this.maxLength});

  final TextEditingController controller;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final used = value.text.characters.length;
        final atLimit = used >= maxLength;
        return Padding(
          padding: EdgeInsets.only(top: AppSpacing.v4, right: AppSpacing.h4),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$used/$maxLength',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: atLimit ? AppColors.pending600 : AppColors.neutral400,
                fontWeight: atLimit ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}
