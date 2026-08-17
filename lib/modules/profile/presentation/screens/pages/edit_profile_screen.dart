import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import '../../../../../utils/assets_path.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/translate.dart';
import '../../../../../utils/years_of_experience.dart';
import '../../../application/profile_provider.dart';
import '../../../domain/profile_models.dart';

import '../../../../../shared/widgets/fk_error_view.dart';
import '../../../../../shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _websiteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  static const _aboutMaxLength = 150;

  /// Index into [kYearsOfExperienceBuckets] — never a label, so a locale change
  /// mid-edit cannot corrupt what gets saved.
  int _yearsIndex = 0;

  bool _prefilled = false;
  bool _isSaving = false;
  bool _didFirstBuild = false;

  @override
  void initState() {
    super.initState();
    // `listenManual` covers both cases in one path: the provider already holds
    // cached data (the common case, since this screen is reached from Manage
    // Profile), and data arriving later. Because it runs outside `build`, no
    // controller is ever mutated mid-build.
    ref.listenManual<AsyncValue<ProfileUser?>>(
      myProfileProvider,
      (previous, next) => next.whenData(_prefillOnce),
      fireImmediately: true,
    );
  }

  void _prefillOnce(ProfileUser? profile) {
    if (_prefilled || profile == null) return;
    _prefilled = true;
    _usernameController.text = profile.username ?? '';
    _aboutController.text = profile.bio ?? '';
    _githubController.text = profile.githubUrl ?? '';
    _linkedInController.text = profile.linkedinUrl ?? '';
    _websiteController.text = profile.websiteUrl ?? '';
    _yearsIndex = yearsOfExperienceIndexFor(profile.yearsOfExperience);

    if (_didFirstBuild) setState(() {});
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _aboutController.dispose();
    _githubController.dispose();
    _linkedInController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral300),
      filled: true,
      fillColor: AppColors.whiteBase,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v16),
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: AppRadius.all03,
        borderSide: BorderSide(color: AppBorders.secondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.all03,
        borderSide: BorderSide(color: AppBorders.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.all03,
        borderSide: const BorderSide(color: AppBorders.blue),
      ),
    );
  }

  void _showYearsOfExperienceBottomSheet(BuildContext context) {
    final labels = yearsOfExperienceLabels(context);
    showCustomDropdown(
      context: context,
      items: labels,
      selectedValue: labels[_yearsIndex],
      onSelected: (value) {
        final index = labels.indexOf(value);
        if (index != -1) setState(() => _yearsIndex = index);
      },
    );
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return Container(
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
                  translate(context, "editProfile.importGallery"),
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsPath.cameraIcon,
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  translate(context, "editProfile.takePhoto"),
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  AssetsPath.dustbinIcon,
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  translate(context, "editProfile.removeCurrentPicture"),
                  style: AppTextStyles.titleLarge.copyWith(color: AppColors.warning600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveConfirmationDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile =
          await _picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Photo pick error: $e");
    }
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
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(translate(context, "editProfile.removePhoto"),
                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w700)),
                12.verticalSpace,
                Text(
                  translate(context, "editProfile.removeConfirmation"),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral500),
                ),
                24.verticalSpace,
                GestureDetector(
                  onTap: () {
                    setState(() => _imageFile = null);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.warning600,
                      borderRadius: AppRadius.all06,
                    ),
                    child: Text(
                      translate(context, "editProfile.delete"),
                      style: AppTextStyles.bodyLarge.copyWith(color: AppBorders.tertiary),
                    ),
                  ),
                ),
                14.verticalSpace,
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(translate(context, "editProfile.cancel"),
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.warning600)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit(ProfileUser? current) async {
    setState(() => _isSaving = true);

    final saved = await ref
        .read(profileActionControllerProvider.notifier)
        .saveProfileDetails(
          ProfileDraft(
            username: _nullIfBlank(_usernameController.text),
            bio: _nullIfBlank(_aboutController.text),
            githubUrl: _nullIfBlank(_githubController.text),
            linkedinUrl: _nullIfBlank(_linkedInController.text),
            websiteUrl: _nullIfBlank(_websiteController.text),
            yearsOfExperience: yearsOfExperienceValueAt(_yearsIndex),
          ),
          current: current,
        );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved) {
      _showSuccessOverlay(context);
    } else {
      // Keep the form contents so a retry costs nothing.
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(translate(context, 'profile.updateError')),
            backgroundColor: AppColors.warning600,
          ),
        );
    }
  }

  String? _nullIfBlank(String value) =>
      value.trim().isEmpty ? null : value.trim();

  @override
  Widget build(BuildContext context) {
    _didFirstBuild = true;
    final profileAsync = ref.watch(myProfileProvider);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          forceMaterialTransparency: true,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back,
                size: 24.sp, color: AppColors.blackBase),
          ),
          title: Text(
            translate(context, "editProfile.title"),
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500),
          ),
        ),
        body: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => FkErrorView(
            message: translate(context, 'profile.loadError'),
            onRetry: () => ref.read(myProfileProvider.notifier).refresh(),
          ),
          data: (profile) => _buildForm(context, profile),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ProfileUser? profile) {
    final photoUrl = profile?.photoUrl;
    final displayName = profile?.displayLabel ?? '';

    return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteBase,
                          borderRadius: AppRadius.all06,
                          border: Border.all(
                            color: AppBorders.secondary,
                          ),
                        ),
                        padding: AppSpacing.all(AppSpacing.h20),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppBorders.blue,
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 35.r,
                                backgroundColor:
                                    AppColors.neutral100,
                                backgroundImage: _imageFile != null
                                    ? FileImage(_imageFile!)
                                    : (photoUrl != null && photoUrl.isNotEmpty
                                        ? NetworkImage(photoUrl)
                                        : null),
                                child: _imageFile == null &&
                                        (photoUrl == null || photoUrl.isEmpty)
                                    ? Text(
                                        displayName.isNotEmpty
                                            ? displayName[0].toUpperCase()
                                            : '?',
                                        style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w500),
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: AppSpacing.h16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold)
                                        ,
                                  ),
                                  SizedBox(height: AppSpacing.v4),
                                  GestureDetector(
                                    onTap: _showImagePickerSheet,
                                    child: Text(
                                      translate(
                                          context, "editProfile.changePhoto"),
                                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.v22),

                      // Username
                      Text(translate(context, "editProfile.username"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.v8),
                      TextFormField(
                        controller: _usernameController,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
                        decoration: _decoration(
                            translate(context, "editProfile.username")),
                      ),
                      SizedBox(height: AppSpacing.v22),

                      // About me
                      Text(translate(context, "editProfile.aboutMe"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.v8),
                      Stack(
                        children: [
                          TextFormField(
                            controller: _aboutController,
                            maxLines: 4,
                            maxLength: _aboutMaxLength,
                            style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
                            onChanged: (_) => setState(() {}),
                            decoration: _decoration(
                                    translate(context, "editProfile.addBio"))
                                .copyWith(
                              counterText: '',
                              contentPadding:
                                  EdgeInsets.fromLTRB(AppSpacing.h16, AppSpacing.h16, AppSpacing.h16, AppSpacing.h22),
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            right: 16.w,
                            child: Text(
                              '${_aboutController.text.length}/$_aboutMaxLength',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.v16),

                      // Years of Experience
                      Text(translate(context, "editProfile.yearsOfExperience"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.v8),
                      GestureDetector(
                        onTap: () => _showYearsOfExperienceBottomSheet(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.h16, vertical: AppSpacing.v16),
                          decoration: BoxDecoration(
                            color: AppColors.whiteBase,
                            borderRadius: AppRadius.all03,
                            border: Border.all(
                                color: AppBorders.secondary),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  yearsOfExperienceLabels(context)[_yearsIndex],
                                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 24.sp,
                                color: AppColors.blackBase,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.v22),

                      // Work & social links
                      Text(translate(context, "editProfile.workSocialLinks"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.v12),
                      _LinkField(
                        icon: AssetsPath.githubSvg,
                        controller: _githubController,
                        hint: translate(context, "editProfile.githubHint"),
                      ),
                      SizedBox(height: AppSpacing.v12),
                      _LinkField(
                        icon: AssetsPath.linkedinSvg,
                        controller: _linkedInController,
                        hint: translate(context, "editProfile.linkedinHint"),
                      ),
                      SizedBox(height: AppSpacing.v12),
                      _LinkField(
                        icon: AssetsPath.websiteSvg,
                        controller: _websiteController,
                        hint: translate(context, "editProfile.websiteHint"),
                      ),

                      SizedBox(height: AppSpacing.v22),
                      Center(
                        child: Padding(
                          padding: AppSpacing.horizontal(AppSpacing.h10),
                          child: Text(
                            translate(context, "editProfile.privacyDisclaimer"),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.v22),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GradientButton(
                              isLoading: _isSaving,
                              // GradientButton.onTap is non-nullable, so guard
                              // a double-submit with a no-op rather than null.
                              onTap: _isSaving ? () {} : () => _submit(profile),
                              text: translate(context, "editProfile.submit"),
                              textStyle: AppTextStyles.bodyLarge.copyWith(color: AppBorders.tertiary),
                              height: 50.h,
                              width: double.infinity,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: _isSaving ? null : () => context.pop(),
                              child: Text(
                                translate(context, "editProfile.cancel"),
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.v22),
                    ],
                  ),
                );
  }

  void _showSuccessOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColors.blackBase.withValues(alpha: 0.7),
      barrierDismissible: false,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AssetsPath.profileUpdated,
                width: 137.sp,
                height: 114.sp,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        if (context.mounted) {
          context.pop();
        }
      }
    });
  }
}

Future<void> showCustomDropdown({
  required BuildContext context,
  required List<String> items,
  required String? selectedValue,
  required Function(String) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        margin: AppSpacing.all(AppSpacing.h16),
        padding: AppSpacing.vertical(AppSpacing.v12),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all06,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.v6),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item == selectedValue;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSelected(item);
              },
              child: Container(
                margin: AppSpacing.horizontal(AppSpacing.h12),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.h16,
                  vertical: AppSpacing.v16,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary100 : Colors.transparent,
                  borderRadius: AppRadius.all04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
                    ),
                    if (isSelected)
                      const Icon(Icons.check,
                          size: 20, color: AppColors.primary500),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

class _LinkField extends StatelessWidget {
  const _LinkField(
      {required this.icon, required this.controller, required this.hint});
  final String icon;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all03,
        border: Border.all(color: AppBorders.secondary),
      ),
      child: TextFormField(
        controller: controller,
        style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral300),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: AppSpacing.h16, vertical: AppSpacing.v16),
          prefixIcon: Padding(
            padding: AppSpacing.all(AppSpacing.h12),
            child: SvgPicture.asset(
              icon,
              height: 20.sp,
              colorFilter:
                  const ColorFilter.mode(AppColors.blackBase, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
