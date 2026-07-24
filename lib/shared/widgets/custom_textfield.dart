import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CustomTextField extends StatefulWidget {
  final String text;

  final TextEditingController? controller;
  final bool isPassword;
  final bool showBorder;
  final bool enablePasswordToggle;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final Color? hintColor;
  final Color? fillColor;
  final Color? borderColor;
  final double? hintFontSize;
  final FontWeight hintFontWeight;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final bool showTickIcon;

  const CustomTextField({
    super.key,
    required this.text,
    this.controller,
    this.focusNode,
    this.isPassword = false,
    this.enablePasswordToggle = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.hintColor,
    this.borderColor,
    this.fillColor = AppColors.neutral50,
    this.validator,
    this.showBorder = false,
    this.hintFontSize,
    this.hintFontWeight = FontWeight.w400,
    this.showTickIcon = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _internalController;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _obscureText = widget.isPassword;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: AppSpacing.horizontal(AppSpacing.s07),
      decoration: BoxDecoration(
        color: widget.fillColor,
        border: widget.showBorder
            ? Border.all(color: widget.borderColor ?? AppBorders.tertiary)
            : null,
        borderRadius: AppRadius.all04,
      ),
      alignment: Alignment.center,
      child: TextFormField(
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.blackBase),
        controller: _internalController,
        focusNode: widget.focusNode,
        obscureText: widget.isPassword && _obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        validator: widget.validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.text,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500),
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s00,
            vertical: AppSpacing.s08,
          ),
          suffixIcon: widget.isPassword && widget.enablePasswordToggle
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : widget.showTickIcon
              ? Padding(
                  padding: AppSpacing.all06,
                  child: SvgPicture.asset(AppAssets.greenTickIcon),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
