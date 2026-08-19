import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/utils/translate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommonSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onMicTap;
  final FocusNode? focusNode;
  final bool readOnly;
  final VoidCallback? onTap;

  /// Opt-in (default false, so existing call sites are unaffected): while
  /// the field is focused, the bar switches to a dark (black bg/white text
  /// and icons) style instead of the default white one.
  final bool darkenOnFocus;

  /// Swaps the mic icon to a filled/active state - e.g. while a caller's
  /// speech-to-text session is listening. Purely visual; the caller owns
  /// the actual listening state.
  final bool isListening;

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
    this.darkenOnFocus = false,
    this.isListening = false,
  });

  @override
  State<CommonSearchBar> createState() => _CommonSearchBarState();
}

class _CommonSearchBarState extends State<CommonSearchBar> {
  FocusNode? _ownedFocusNode;
  bool _isFocused = false;

  FocusNode get _focusNode => widget.focusNode ?? _ownedFocusNode!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _ownedFocusNode = FocusNode();
    }
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!widget.darkenOnFocus) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.darkenOnFocus && _isFocused;
    final fg = isDark ? AppColors.whiteBase : AppColors.blackBase;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: isDark ? AppColors.blackBase : AppColors.whiteBase,
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
              Icon(Icons.search_rounded, size: 20.sp, color: fg),
              12.horizontalSpace,
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  cursorColor: fg,
                  style: AppTextStyles.bodyMedium.copyWith(color: fg),
                  decoration: InputDecoration(
                    hintText:
                        widget.hintText ??
                        translate(context, 'common.searchEvents'),
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.neutral400 : AppColors.neutral500,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Container(color: fg, width: AppSpacing.v2, height: 25),
              8.horizontalSpace,
              GestureDetector(
                onTap: widget.onMicTap,
                child: Icon(
                  widget.isListening ? Icons.mic : Icons.mic_none,
                  color: widget.isListening ? AppColors.primary500 : fg,
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
