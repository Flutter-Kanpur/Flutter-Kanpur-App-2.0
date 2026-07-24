import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';

// import '../../../../services/remote_config_service.dart';
import '../../../utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import '../../../utils/translate.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
// import '../../domain/entities/profile_entity.dart';
// import '../bloc/profile_bloc.dart';
// import '../bloc/profile_event.dart';

class AddSkillsBottomSheet extends StatefulWidget {
  // final ProfileEntity profile;
  final Function(List<String> skills) onSave;
  const AddSkillsBottomSheet({
    super.key,
    // required this.profile,
    required this.onSave,
  });

  @override
  State<AddSkillsBottomSheet> createState() => _AddSkillsBottomSheetState();
}

class _AddSkillsBottomSheetState extends State<AddSkillsBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedSkills = {};
  String _searchQuery = '';
  bool _showInlineAddOther = false;
  TextEditingController? _inlineAddOtherController;
  final FocusNode _inlineAddOtherFocusNode = FocusNode();

  late final List<String> _predefinedSkills;

  @override
  void initState() {
    super.initState();
    // _predefinedSkills = RemoteConfigService.instance.onboardingScreen3Options;
    // _selectedSkills.addAll(widget.profile.skills);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _inlineAddOtherController?.dispose();
    _inlineAddOtherFocusNode.dispose();
    super.dispose();
  }

  List<String> get _filteredSkills {
    if (_searchQuery.trim().isEmpty) {
      return _predefinedSkills.take(5).toList();
    }
    final q = _searchQuery.trim().toLowerCase();
    return _predefinedSkills.where((s) => s.toLowerCase().contains(q)).toList();
  }

  void _startInlineAddOther() {
    if (_showInlineAddOther) return;
    _inlineAddOtherController = TextEditingController();
    setState(() => _showInlineAddOther = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inlineAddOtherFocusNode.requestFocus();
    });
  }

  void _commitInlineAddOther() {
    final value = _inlineAddOtherController?.text.trim() ?? '';
    _inlineAddOtherController?.dispose();
    _inlineAddOtherController = null;
    _inlineAddOtherFocusNode.unfocus();
    setState(() => _showInlineAddOther = false);
    if (value.isEmpty) return;
    if (_predefinedSkills.any((s) => s.toLowerCase() == value.toLowerCase())) return;
    setState(() {
      _selectedSkills.add(value);
    });
    _saveSuggestedSkillToFirestore(value);
  }

  void _saveSuggestedSkillToFirestore(String value) {
    try {
      // FirebaseFirestore.instance.collection('suggested_skills').add({
      //   'value': value,
      //   'source': 'manage_profile',
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
    } catch (e) {
      debugPrint('Could not save suggested skill to Firestore: $e');
    }
  }

  void _cancelInlineAddOther() {
    _inlineAddOtherController?.dispose();
    _inlineAddOtherController = null;
    _inlineAddOtherFocusNode.unfocus();
    setState(() => _showInlineAddOther = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r07),
          topRight: Radius.circular(AppRadius.r07),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.s05,
        right: AppSpacing.s05,
        top: AppSpacing.s05,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.blackBase,
                  borderRadius: AppRadius.all01,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.s09),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "profile.addSkills"),
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded, color: AppColors.blackBase),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.neutral50,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.s07),
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: AppRadius.all09,
                border: Border.all(color: AppBorders.secondary),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.neutral900,
        ),
                decoration: InputDecoration(
                  hintText: translate(context, "profile.searchRolesSkills"),
                  hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.s07,
                    vertical: AppSpacing.s07,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: AppSpacing.s06, top: AppSpacing.s07, bottom: AppSpacing.s07),
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: SvgPicture.asset(
                        AssetsPath.explore,
                        colorFilter: const ColorFilter.mode(AppColors.neutral300, BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.s09),
            Wrap(
              spacing: AppSpacing.s05,
              runSpacing: AppSpacing.s05,
              children: [
                ..._filteredSkills.map((skill) {
                  final isSelected = _selectedSkills.contains(skill);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSkills.remove(skill);
                        } else {
                          _selectedSkills.add(skill);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 150),
                      padding: AppSpacing.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s04),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary500.withValues(alpha: 0.12)
                            : AppColors.whiteBase,
                        borderRadius: AppRadius.all06,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary500
                              : AppBorders.secondary,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        skill,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.primary500
                              : AppColors.neutral900,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
                if (_showInlineAddOther && _inlineAddOtherController != null)
                  _buildInlineAddOtherChip(),
              ],
            ),
            SizedBox(height: AppSpacing.s10),
            GestureDetector(
              onTap: _startInlineAddOther,
              child: Text(
                translate(context, "profile.addOther"),
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary500, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: AppSpacing.s09),
            GradientButton(
              onTap: () {
                widget.onSave(_selectedSkills.toList());
                Navigator.of(context).pop();
              },
              text: translate(context, "profile.saveChanges"),
              textStyle:
                  AppTextStyles.titleMedium.copyWith(color: AppColors.whiteBase),
            ),
            SizedBox(height: AppSpacing.s09),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineAddOtherChip() {
    return Container(
      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 200.w),
      padding: EdgeInsets.only(left: AppSpacing.s07, right: AppSpacing.s04, top: AppSpacing.s03, bottom: AppSpacing.s03),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all06,
        border: Border.all(
          color: AppBorders.blue,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _inlineAddOtherController,
              focusNode: _inlineAddOtherFocusNode,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: translate(context, 'profile.enterSkill'),
                hintStyle: AppTextStyles.bodyLarge,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onSubmitted: (_) => _commitInlineAddOther(),
            ),
          ),
          GestureDetector(
            onTap: _cancelInlineAddOther,
            child: Icon(
              Icons.close,
              size: 18.sp,
              color: AppColors.blackBase,
            ),
          ),
        ],
      ),
    );
  }
}
