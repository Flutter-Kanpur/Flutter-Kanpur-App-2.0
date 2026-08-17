import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/custom_textfield.dart';
import 'package:flutter_knp_mobile_app_v2/utils/assets_path.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/presentation/widgets/onboarding_profile_avatar.dart';
import 'package:flutter_knp_mobile_app_v2/core/utils/image_compress_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/modules/onboarding/application/onboarding_provider.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_confirm_dialog.dart';

class OnboardingProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onNext;

  const OnboardingProfileScreen({super.key, this.onNext});

  @override
  ConsumerState<OnboardingProfileScreen> createState() =>
      _OnboardingProfileScreenState();
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

class _OnboardingProfileScreenState
    extends ConsumerState<OnboardingProfileScreen> {
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
  final draft = ref.read(onboardingProvider);
  nameController.text = draft.fullName;
  _localFilePath = draft.localPhotoPath;

  nameController.addListener(() {
    final text = nameController.text.trim();
    setState(() {
      _isTyping = text.isNotEmpty;
      if (text.isNotEmpty) {
        _hasError = false;
      }
    });
    ref.read(onboardingProvider.notifier).setFullName(text);
  });
}

  @override
  void dispose() {
    nameController.dispose();
    nameFocusNode.removeListener(_scrollToFocusedField);
    super.dispose();
  }

  void _scrollToFocusedField() {
    final nodes = [nameFocusNode];
    final keys = [nameFieldKey];

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

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() => _isLoading = false);
      await ref.read(onboardingProvider.notifier).setFullName(name);
await ref.read(onboardingProvider.notifier).setStep(1);
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
            padding: AppSpacing.all(AppSpacing.h20),
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
                  height: AppSpacing.v16,
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
                    'onboarding.importFromGallery'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.blackBase,
                    ),
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
                    'onboarding.takePhoto'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.blackBase,
                    ),
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
                    'onboarding.removeCurrentPicture'.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.warning600,
                    ),
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
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile == null) return;
    if (!mounted) return;

    String pathToUse = pickedFile.path;
    try {
      final compressed =
          await ImageCompressHelper.compressToAvatar(pickedFile.path);
      if (compressed != null) pathToUse = compressed;
    } catch (_) {
      // keep original path if compress fails
    }

    // Save to Riverpod FIRST (survives screen remount after gallery/camera)
    await ref.read(onboardingProvider.notifier).setPhotoPath(pathToUse);

    if (!mounted) return;
    setState(() {
      _fileError = null;
      _localFilePath = pathToUse;
    });
  } catch (e) {
    if (!mounted) return;
    setState(() {
      _fileError = 'onboarding.imagePickError'.tr();
    });
  }
}

 Future<void> _removeProfileImage() async {
  setState(() {
    _localFilePath = null;
    _localPhotoUrl = null;
  });
  await ref.read(onboardingProvider.notifier).setPhotoPath(null);
}

  void _showRemoveConfirmationDialog() {
  FkConfirmDialog.show(
  context,
  title: 'onboarding.removePhotoTitle'.tr(),
  message: 'onboarding.removePhotoSubTitle'.tr(),
  confirmLabel: 'onboarding.delete'.tr(),
  cancelLabel: 'onboarding.cancel'.tr(),
  onConfirm: () async {
    await _removeProfileImage();
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
                  minHeight:
                      constraints.maxHeight -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Layout.topPadding(context).verticalSpace,

                      _buildAvatarSection(context),
                      if (_fileError != null) ...[
  SizedBox(height: 8.h),
  Text(
    _fileError!,
    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning600),
    textAlign: TextAlign.center,
  ),
],

                      _Layout.sectionSpacing(context).verticalSpace,

                      _buildForm(context),

                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: GradientButton(
                          isLoading: _isLoading,
                          onTap: _goToNextScreen,
                          text: 	
'onboarding.continue'.tr(),
                          textStyle: AppTextStyles.bodyLarge.copyWith(
                            color: AppBorders.tertiary,
                          ),
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
  final draft = ref.watch(onboardingProvider);
  final path = draft.localPhotoPath ?? _localFilePath;

  return OnboardingProfileAvatar(
    localPhotoPath: path,
    networkPhotoUrl: _localPhotoUrl,
    onAddTap: _showImagePickerSheet,
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
  showTickIcon:
      nameController.text.isNotEmpty &&
      nameController.text.length > 4,
  text: 'onboarding.fullName'.tr(),
  // showBorder: _hasError ||
  //     nameFocusNode.hasFocus ||
  //     nameController.text.isNotEmpty,
  // borderColor: _hasError
  //     ? AppColors.warning600
  //     : nameFocusNode.hasFocus
  //         ? AppColors.primary500
  //         : AppColors.neutral100,
  // fillColor: _hasError ||
  //         nameFocusNode.hasFocus ||
  //         nameController.text.isNotEmpty
  //     ? Colors.transparent
  //     : AppColors.neutral50,
),
          ),
          if (_hasError)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.v8),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: AppColors.warning600,
                    size: 18.sp,
                  ),
                  6.horizontalSpace,
                  Text(
                   	
'onboarding.fullNameError'.tr(),
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
