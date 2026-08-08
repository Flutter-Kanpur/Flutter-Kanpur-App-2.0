import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final bool isPassword;
  final bool enablePasswordToggle;
  final bool showTickIcon;

  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;

  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.text,
    this.controller,
    this.focusNode,
    this.validator,
    this.isPassword = false,
    this.enablePasswordToggle = true,
    this.showTickIcon = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  late bool _obscureText;

  String? _errorText;

  bool get hasFocus => widget.focusNode?.hasFocus ?? false;

  bool get hasText => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _obscureText = widget.isPassword;

    widget.focusNode?.addListener(_refresh);
    _controller.addListener(_refresh);
  }

  void _refresh() {
    if (!mounted) return;

    if (_errorText != null) {
      _errorText = widget.validator?.call(_controller.text);
    }

    setState(() {});
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_refresh);
    _controller.removeListener(_refresh);

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  Color get borderColor {
    if (_errorText != null) return Colors.red;

    if (hasFocus) return AppColors.primary500;

    if (hasText) return AppColors.borderSecondary;

    return Colors.transparent;
  }

  Color get fillColor {
    if (hasFocus || widget.controller!.text.isNotEmpty) return Colors.white;

    return const Color(0xFFF6F6F6);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(AppRadius.radius04),
            border: Border.all(
              color: borderColor,
              width: 1.2,
            ),
            boxShadow: hasFocus && _errorText == null
                ? [
              BoxShadow(
                color: AppColors.primary500.withOpacity(.15),
                spreadRadius: 2,
                blurRadius: 0,
              ),
            ]
                : [],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.h16,
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            obscureText: widget.isPassword && _obscureText,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            validator: (value) {
              final error = widget.validator?.call(value);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;

                if (_errorText != error) {
                  setState(() {
                    _errorText = error;
                  });
                }
              });

              return error;
            },

            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.blackBase,
            ),

            decoration: InputDecoration(
              border: InputBorder.none,

              errorStyle: const TextStyle(
                height: 0,
                fontSize: 0,
              ),

              hintText: widget.text,

              hintStyle: AppTextStyles.titleMedium.copyWith(
                color: AppColors.neutral500,
              ),

              contentPadding: EdgeInsets.symmetric(
                vertical: AppSpacing.v18,
              ),

              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: _errorText != null
                      ? Colors.red
                      : AppColors.neutral500,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : widget.showTickIcon
                  ? Padding(
                padding: AppSpacing.all(AppSpacing.h12),
                child: SvgPicture.asset(
                  AppAssets.greenTickIcon,
                ),
              )
                  : null,
            ),
          ),
        ),

        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.h16,
              top: 6,
            ),
            child: Text(
              _errorText!,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }
}