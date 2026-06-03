import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';


import '../../utils/assets_path.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/translate.dart';
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
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
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
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              translate(context, "profile.roleExperience"),
              style: textStyle_16MediumBlack().copyWith(fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            _buildExperienceDropdown(),
            SizedBox(height: 20.h),
            TextField(
              controller: _searchController,
              style: textStyle_14RegularBlack().copyWith(
                color: const Color(0xFF3D3D3D),
              ),
              decoration: InputDecoration(
                hintText: translate(context, "profile.searchRolesSkills"),
                hintStyle: textStyle_14RegularGrey(),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ..._filteredRoles.map((role) {
                  final isSelected = _selectedRoles.contains(role);
                  return GestureDetector(
                    onTap: () => _toggleRole(role),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF4167F2).withValues(alpha: 0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF4167F2)
                              : AppColors.communityBorderColor,
                        ),
                      ),
                      child: Text(
                        role,
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
                widget.onSave(_selectedRoles.toList(), _selectedExperience);
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

  Widget _buildExperienceDropdown() {
    final List<String> experienceList = ["0-1", "1-2", "2-3", "3-4"];

    return GestureDetector(
      onTap: () async {
        final RenderBox? renderBox =
            _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) return;
        final Offset offset = renderBox.localToGlobal(Offset.zero);
        final Size size = renderBox.size;

        final Rect rect =
            Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);

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
          color: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          items: experienceList.map((exp) {
            final bool isSelected = _selectedExperience == exp;
            return PopupMenuItem<String>(
              value: exp,
              padding: EdgeInsets.zero,
              child: Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                padding:
                    EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFDCE5FD) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$exp ${translate(context, "profile.yearsSuffix")}",
                      style: textStyle_16RegularBlack()
                          .copyWith(color: const Color(0XFF000000)),
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
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 18.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedExperience != null
                  ? "$_selectedExperience ${translate(context, 'profile.yearsSuffix')}"
                  : translate(context, "profile.yearsOfExperience"),
              style: TextStyle(
                color: _selectedExperience != null ? Colors.black : Colors.grey,
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
                hintText: translate(context, 'profile.enterRole'),
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
