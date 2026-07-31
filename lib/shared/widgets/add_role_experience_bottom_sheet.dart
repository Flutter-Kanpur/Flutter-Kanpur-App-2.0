import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';

import '../../utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import '../../utils/translate.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
// import '../../domain/entities/profile_entity.dart';

class AddRoleExperienceBottomSheet extends StatefulWidget {
  // final ProfileEntity profile;
  final Function(List<String> roles, String? experience) onSave;
  const AddRoleExperienceBottomSheet({
    super.key,
    // required this.profile,
    required this.onSave,
  });

  @override
  State<AddRoleExperienceBottomSheet> createState() =>
      _AddRoleExperienceBottomSheetState();
}

class _AddRoleExperienceBottomSheetState
    extends State<AddRoleExperienceBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedRoles = {};
  String _searchQuery = '';
  bool _showInlineAddOther = false;
  TextEditingController? _inlineAddOtherController;
  final FocusNode _inlineAddOtherFocusNode = FocusNode();
  String? _selectedExperience;
  final GlobalKey _dropdownKey = GlobalKey();

  late final List<String> _predefinedRoles;

  @override
  void initState() {
    super.initState();
    // _predefinedRoles = RemoteConfigService.instance.onboardingScreen2Options;
    // _selectedRoles.addAll(widget.profile.roleTags);
    // _selectedExperience = widget.profile.yearsOfExperience;
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

  List<String> get _allRoles => [..._predefinedRoles];

  List<String> get _filteredRoles {
    if (_searchQuery.trim().isEmpty) {
      return _allRoles.take(5).toList();
    }
    final q = _searchQuery.trim().toLowerCase();
    return _allRoles.where((s) => s.toLowerCase().contains(q)).toList();
  }

  void _toggleRole(String role) {
    setState(() {
      if (_selectedRoles.contains(role)) {
        _selectedRoles.remove(role);
      } else {
        _selectedRoles.add(role);
      }
    });
  }

  void _startInlineAddOther() {
    setState(() {
      _showInlineAddOther = true;
      _inlineAddOtherController = TextEditingController();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inlineAddOtherFocusNode.requestFocus();
    });
  }

  void _commitInlineAddOther() {
    final value = _inlineAddOtherController?.text.trim() ?? '';
    if (value.isNotEmpty && !_allRoles.contains(value)) {
      setState(() {
        _selectedRoles.add(value);
      });
      _saveSuggestedRoleToFirestore(value);
    }
    _cancelInlineAddOther();
  }

  void _cancelInlineAddOther() {
    setState(() {
      _showInlineAddOther = false;
      _inlineAddOtherController?.dispose();
      _inlineAddOtherController = null;
    });
  }

  void _saveSuggestedRoleToFirestore(String value) {
    try {
      // FirebaseFirestore.instance.collection('suggested_roles').add({
      //   'value': value,
      //   'userId': widget.profile.userId,
      //   'createdAt': FieldValue.serverTimestamp(),
      // });
    } catch (e) {
      debugPrint('Could not save suggested role: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.h10,
        right: AppSpacing.h10,
        top: AppSpacing.v10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r06),
          topRight: Radius.circular(AppRadius.r06),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppBorders.secondary,
                  borderRadius: AppRadius.all01,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.v22),
            Text(
              translate(context, "profile.roleExperience"),
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v22),
            _buildExperienceDropdown(),
            SizedBox(height: AppSpacing.v20),
            TextField(
              controller: _searchController,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral900,
              ),
              decoration: InputDecoration(
                hintText: translate(context, "profile.searchRolesSkills"),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.neutral500,
                  fontWeight: FontWeight.w300,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.neutral400),
                filled: true,
                fillColor: AppColors.neutral50,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.all03,
                  borderSide: BorderSide.none,
                ),
                contentPadding: AppSpacing.vertical(AppSpacing.v12),
              ),
            ),
            SizedBox(height: AppSpacing.v20),
            Wrap(
              spacing: AppSpacing.h8,
              runSpacing: AppSpacing.v8,
              children: [
                ..._filteredRoles.map((role) {
                  final isSelected = _selectedRoles.contains(role);
                  return GestureDetector(
                    onTap: () => _toggleRole(role),
                    child: Container(
                      padding: AppSpacing.symmetric(
                        horizontal: AppSpacing.h16,
                        vertical: AppSpacing.v10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary500.withValues(alpha: 0.12)
                            : AppColors.whiteBase,
                        borderRadius: AppRadius.all06,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary500
                              : AppColors.neutral100,
                        ),
                      ),
                      child: Text(
                        role,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected
                              ? AppColors.primary500
                              : AppColors.neutral900,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }),
                if (_showInlineAddOther && _inlineAddOtherController != null)
                  _buildInlineAddOtherChip(),
              ],
            ),
            SizedBox(height: AppSpacing.v22),
            GestureDetector(
              onTap: _startInlineAddOther,
              child: Text(
                translate(context, "profile.addOther"),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.v20),
            GradientButton(
              onTap: () {
                widget.onSave(_selectedRoles.toList(), _selectedExperience);
                Navigator.of(context).pop();
              },
              text: translate(context, "profile.saveChanges"),
              textStyle: AppTextStyles.titleMedium.copyWith(
                color: AppColors.whiteBase,
              ),
            ),
            SizedBox(height: AppSpacing.v20),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceDropdown() {
    final List<String> experienceList = ["0-1", "1-2", "2-3", "3-4"];

    return GestureDetector(
      onTap: () async {
        final RenderBox? renderBox =
            _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) return;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final Rect rect = Rect.fromLTWH(
          offset.dx,
          offset.dy,
          size.width,
          size.height,
        );

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromRect(
            rect.translate(0, size.height),
            Offset.zero & MediaQuery.of(context).size,
          ),
          constraints: BoxConstraints(
            minWidth: size.width,
            maxWidth: size.width,
          ),
          color: AppColors.whiteBase,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.all06),
          items: experienceList.map((exp) {
            final bool isSelected = _selectedExperience == exp;
            return PopupMenuItem<String>(
              value: exp,
              padding: EdgeInsets.zero,
              child: Container(
                width: size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h12,
                  vertical: AppSpacing.v6,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary100 : Colors.transparent,
                  borderRadius: AppRadius.all03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$exp ${translate(context, "profile.yearsSuffix")}",
                      style: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.blackBase)
                          .copyWith(color: AppColors.blackBase),
                    ),
                    if (isSelected)
                      SvgPicture.asset(
                        AssetsPath.tickIcon,
                        height: 18,
                        width: 18,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

        if (selected != null) {
          setState(() {
            _selectedExperience = selected;
          });
        }
      },
      child: Container(
        key: _dropdownKey,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h10,
          vertical: AppSpacing.v18,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all04,
          border: Border.all(color: AppBorders.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedExperience != null
                  ? "$_selectedExperience ${translate(context, 'profile.yearsSuffix')}"
                  : translate(context, "profile.yearsOfExperience"),
              style: AppTextStyles.bodyMedium.copyWith(
                color: _selectedExperience != null
                    ? AppColors.blackBase
                    : AppColors.neutral400,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineAddOtherChip() {
    return Container(
      constraints: BoxConstraints(minWidth: 120.w, maxWidth: 200.w),
      padding: EdgeInsets.only(
        left: AppSpacing.h16,
        right: AppSpacing.h8,
        top: AppSpacing.v6,
        bottom: AppSpacing.v6,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all06,
        border: Border.all(color: AppBorders.blue, width: 1.5),
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
                hintText: translate(context, 'profile.enterRole'),
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
            child: Icon(Icons.close, size: 18.sp, color: AppColors.blackBase),
          ),
        ],
      ),
    );
  }
}
