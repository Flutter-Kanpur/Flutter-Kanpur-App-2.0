import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';

// import '../../../../services/remote_config_service.dart';
import '../../../utils/assets_path.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/translate.dart';
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
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
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translate(context, "profile.addSkills"),
                  style: textStyle_18BoldBlack(),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.black),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F6F6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: AppColors.communityBorderColor),
              ),
              child: TextField(
                controller: _searchController,
                style: textStyle_14RegularBlack().copyWith(
          color: const Color(0xFF3D3D3D),
        ),
                decoration: InputDecoration(
                  hintText: translate(context, "profile.searchRolesSkills"),
                  hintStyle: textStyle_16RegularGrey(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  suffixIcon: Padding(
                    padding: EdgeInsets.only(right: 12.w, top: 15.h, bottom: 15.h),
                    child: SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: SvgPicture.asset(
                        AssetsPath.explore,
                        colorFilter: const ColorFilter.mode(AppColors.contributorFieldHintColor, BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
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
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4167F2).withValues(alpha: 0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4167F2)
                              : const Color(0xFFE3E3E3),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        skill,
                        style: textStyle_14RegularBlack().copyWith(
                          color: isSelected
                              ? const Color(0xFF4167F2)
                              : const Color(0xFF3D3D3D),
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
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: _startInlineAddOther,
              child: Text(
                translate(context, "profile.addOther"),
                style: textStyle_16BoldLinkBlue().copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GradientButton(
              onTap: () {
                widget.onSave(_selectedSkills.toList());
                Navigator.of(context).pop();
              },
              text: translate(context, "profile.saveChanges"),
              textStyle:
                  textStyle_16MediumBlack().copyWith(color: Colors.white),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineAddOtherChip() {
    return Container(
      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 200.w),
      padding: EdgeInsets.only(left: 14.w, right: 8.w, top: 6.h, bottom: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFF4167F2),
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
              style: textStyle_16RegularBlack().copyWith(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: translate(context, 'profile.enterSkill'),
                hintStyle: textStyle_16RegularGrey().copyWith(fontSize: 14.sp),
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
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
