import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/custom_textfield.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';


class OnboardingProfileScreen extends StatefulWidget {
  final VoidCallback? onNext;

  const OnboardingProfileScreen({
    super.key,
    this.onNext,
  });

  @override
  State<OnboardingProfileScreen> createState() => _OnboardingProfileScreenState();
}

/// Scale-aware layout constants for different screen sizes.
class _Layout {
  static double avatarRadius(BuildContext context) => 50.r;
  static double avatarIconSize(BuildContext context) => 40.sp;
  static double addButtonRadius(BuildContext context) => 12.r;
  static double addButtonIconSize(BuildContext context) => 14.sp;
  static double addButtonOffset(BuildContext context) => 5.r;
  static double horizontalPadding(BuildContext context) => 24.w;
  static double topPadding(BuildContext context) => 30.h;
  static double sectionSpacing(BuildContext context) => 24.h;
  // static double usernameTopPadding(BuildContext context) => 12.h;
  static double buttonBottomPadding(BuildContext context) => 12.h;
  static double buttonHeight(BuildContext context) => 48.h;
}

class _OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  bool _hasError = false;
  bool _isLoading = false;
  bool _isTyping = false;
  bool _isNameValid = false;
  String? _fileError;

  final _formKey = GlobalKey<FormState>();
  final nameFieldKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final nameFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  String? _localFilePath;
  String? _localPhotoUrl;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      final text = nameController.text.trim();
      setState(() {
        _isTyping = text.isNotEmpty;
        if (text.isNotEmpty) {
          _hasError = false;
        }
      });
    });
  }


  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.removeListener(_scrollToFocusedField);
    super.dispose();
  }

  void _scrollToFocusedField() {
    final nodes = [
      nameFocusNode,
    ];
    final keys = [
      nameFieldKey,
    ];

    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].hasFocus && keys[i].currentContext != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Scrollable.ensureVisible(
            keys[i].currentContext!,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
        break;
      }
    }
  }


  void _goToNextScreen() async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      widget.onNext?.call();
    }
  }


  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: AppSpacing.all09,
            decoration: BoxDecoration(
              color: AppColors.whiteBase,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.r07),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 75.w,
                  height: AppSpacing.s07,
                  decoration: BoxDecoration(
                    color: AppColors.blackBase,
                    borderRadius: AppRadius.all02,
                  ),
                ),
                20.verticalSpace,
                ListTile(
                  leading: SvgPicture.asset(
                    AssetsPath.importIcon,
                    width: 24.w,
                    height: 24.h,
                  ),
                  title: Text(
                    "Import from gallery",
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    AssetsPath.cameraIcon,
                    width: 24.w,
                    height: 24.h,
                  ),
                  title: Text(
                    "Take Photo",
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUploadImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    AssetsPath.dustbinIcon,
                    width: 24.w,
                    height: 24.h,
                  ),
                  title: Text(
                    "Remove current picture",
                    style: AppTextStyles.titleLarge.copyWith(color: AppColors.warning600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showRemoveConfirmationDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final pickedFile =
      await _picker.pickImage(source: source, imageQuality: 70);

      if (pickedFile == null) return;

      final extension = pickedFile.path.split('.').last.toLowerCase();

      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        setState(() {
          _fileError = "Please select a JPG or PNG image.";
        });
        return;
      }

      setState(() {
        _fileError = null;
        _localFilePath = pickedFile.path;
      });
    } catch (e) {
      print("Upload error: $e");
    }
  }

  Future<void> _removeProfileImage() async {
    setState(() {
      _localFilePath = null;
      _localPhotoUrl = null;
    });
  }

  void _showRemoveConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.whiteBase,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.all07,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s08),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Remove?", style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w700)),
                12.verticalSpace,
                Text(
                  "Are you sure want to remove the profile photo?",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                ),
                24.verticalSpace,
                GradientButton(
                  color: AppColors.warning600,
                  onTap: () async {
                    Navigator.pop(context);
                    await _removeProfileImage();
                  },
                  text: "Delete",
                ),
                14.verticalSpace,
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text("Cancel", style: AppTextStyles.bodyLarge.copyWith(color: AppColors.warning600)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = _Layout.buttonBottomPadding(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: _Layout.horizontalPadding(context),
                right: _Layout.horizontalPadding(context),
                bottom: bottomPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Layout.topPadding(context).verticalSpace,

                      _buildAvatarSection(context),

                      _Layout.sectionSpacing(context).verticalSpace,

                      _buildForm(context),

                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: GradientButton(
                          isLoading: _isLoading,
                          onTap: _goToNextScreen,
                          text: "Continue",
                          textStyle: AppTextStyles.bodyLarge.copyWith(color: AppBorders.tertiary),
                          height: _Layout.buttonHeight(context),
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: _Layout.avatarRadius(context),
          backgroundColor: AppColors.neutral50,
          backgroundImage: _localFilePath != null
              ? FileImage(File(_localFilePath!))
              : (_localPhotoUrl != null
              ? NetworkImage(_localPhotoUrl!) as ImageProvider
              : null),
          child: (_localFilePath == null && _localPhotoUrl == null)
              ? SvgPicture.asset(
            AssetsPath.emptyImage,
            color: AppColors.blackBase,
            height: _Layout.avatarIconSize(context),
          )
              : null,
        ),
        Positioned(
          bottom: _Layout.addButtonOffset(context),
          right: _Layout.addButtonOffset(context),
          child: GestureDetector(
            onTap: _showImagePickerSheet,
            child: CircleAvatar(
              radius: _Layout.addButtonRadius(context),
              backgroundColor: AppColors.primary500,
              child: Icon(
                Icons.add,
                size: _Layout.addButtonIconSize(context),
                color: AppColors.whiteBase,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: nameFieldKey,
            child: CustomTextField(
              controller: nameController,
              focusNode: nameFocusNode,
              showTickIcon: nameController.text.isNotEmpty &&
                  nameController.text.length > 4,
              text: "Full name",
              showBorder:
              nameFocusNode.hasFocus || nameController.text.isNotEmpty,
              borderColor: nameFocusNode.hasFocus
                  ? AppColors.primary500
                  : nameController.text.isNotEmpty
                  ? AppColors.neutral100
                  : AppColors.neutral50,
              fillColor:
              nameFocusNode.hasFocus || nameController.text.isNotEmpty
                  ? Colors.transparent
                  : AppColors.neutral50,
            ),
          ),
          if (_hasError)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.s04),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: AppColors.warning600,
                    size: 18.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                    "Please enter your name.",
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
