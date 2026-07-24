import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import '../../../../../utils/assets_path.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/translate.dart';

import '../../../../../shared/widgets/gradiant_background.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _githubController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _websiteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  static const _aboutMaxLength = 150;
  String _yearsOfExperience = '0-1 years';
  // bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Load profile when screen starts
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final authState = context.read<AuthBloc>().state;
    //   if (authState is Authenticated) {
    //     context.read<ProfileBloc>().add(LoadProfile(authState.user.id));
    //   }
    // });
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

  // void _prefillFromProfile( profile, String? authEmail) {
  //   if (_initialized || profile == null) return;
  //   if (profile.fullName == null &&
  //       profile.about == null &&
  //       profile.github == null) {}
  //
  //   _initialized = true;
  //   final emailPrefix = authEmail?.split('@').first ?? '';
  //
  //   _usernameController.text = profile.fullName ?? '';
  //
  //   _aboutController.text = profile.about ?? '';
  //
  //   _githubController.text = profile.github ?? 'github.com/$emailPrefix';
  //   _linkedInController.text =
  //       profile.linkedin ?? 'linkedin.com/in/$emailPrefix';
  //   _websiteController.text = profile.website ?? '';
  //
  //   _yearsOfExperience = profile.yearsOfExperience ?? '0-1 years';
  // }

  InputDecoration _decoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(color: AppColors.neutral300),
      filled: true,
      fillColor: AppColors.whiteBase,
      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
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

  static List<String> _getYearsOfExperienceOptions(BuildContext context) => [
        translate(context, "editProfile.yearsOptions.year_0_1"),
        translate(context, "editProfile.yearsOptions.year_1_2"),
        translate(context, "editProfile.yearsOptions.year_2_3"),
        translate(context, "editProfile.yearsOptions.year_3_5"),
        translate(context, "editProfile.yearsOptions.year_5_plus"),
      ];

  void _showYearsOfExperienceBottomSheet(BuildContext context) {
    showCustomDropdown(
      context: context,
      items: _getYearsOfExperienceOptions(context),
      selectedValue: _yearsOfExperience,
      onSelected: (value) => setState(() => _yearsOfExperience = value),
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
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s08),
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

  // Future<void> _submit(BuildContext context) async {
  //   // final authState = context.read<AuthBloc>().state;
  //   // if (authState is! Authenticated) return;
  //   // final profileState = context.read<ProfileBloc>().state;
  //   // final existing =
  //   //     profileState is ProfileLoaded ? profileState.profile : null;
  //   final userId = 1;
  //   final nameValue = _usernameController.text.trim();

  //   // String? photoUrl = _imageFile != null
  //   //     ? null
  //   //     : (authState.user.photoURL ?? existing?.photoUrl);

  //   String? photoUrl = "https://www.magnific.com/free-photos-vectors/user-profile";

  //   // if (_imageFile != null) {
  //   //   try {
  //   //     final storageRef = FirebaseStorage.instance
  //   //         .ref()
  //   //         .child('profile_images')
  //   //         .child('$userId.jpg');
  //   //     await storageRef.putFile(_imageFile!);
  //   //     photoUrl = await storageRef.getDownloadURL();
  //   //   } catch (e) {
  //   //     debugPrint("Error uploading photo: $e");
  //   //     if (mounted) {
  //   //       ScaffoldMessenger.of(context).showSnackBar(
  //   //         SnackBar(
  //   //             content:
  //   //                 Text(translate(context, "editProfile.photoUploadError"))),
  //   //       );
  //   //     }
  //   //     return;
  //   //   }
  //   // }

  //   final entity = ProfileEntity(
  //     userId: userId,
  //     fullName: nameValue,
  //     displayName: nameValue,
  //     photoUrl: photoUrl,
  //     username: nameValue.toLowerCase().replaceAll(' ', '_'),
  //     about: _aboutController.text.trim().isEmpty
  //         ? null
  //         : _aboutController.text.trim(),
  //     yearsOfExperience: _yearsOfExperience,
  //     github: _githubController.text.trim().isEmpty
  //         ? null
  //         : _githubController.text.trim(),
  //     linkedin: _linkedInController.text.trim().isEmpty
  //         ? null
  //         : _linkedInController.text.trim(),
  //     website: _websiteController.text.trim().isEmpty
  //         ? null
  //         : _websiteController.text.trim(),
  //     skills: existing?.skills ?? [],
  //     roleTags: existing?.roleTags ?? [],
  //   );
  //   context.read<ProfileBloc>().add(UpdateProfile(entity));
  // }

  @override
  Widget build(BuildContext context) {
    String photoUrl = "https://www.magnific.com/free-photos-vectors/user-profile";
    String displayName = "John Doe";
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
        body: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
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
                        padding: AppSpacing.all09,
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
                            SizedBox(width: AppSpacing.s07),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold)
                                        ,
                                  ),
                                  SizedBox(height: AppSpacing.s02),
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
                      SizedBox(height: AppSpacing.s10),

                      // Username
                      Text(translate(context, "editProfile.username"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.s04),
                      TextFormField(
                        controller: _usernameController,
                        style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase),
                        decoration: _decoration(
                            translate(context, "editProfile.username")),
                      ),
                      SizedBox(height: AppSpacing.s10),

                      // About me
                      Text(translate(context, "editProfile.aboutMe"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.s04),
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
                                  EdgeInsets.fromLTRB(AppSpacing.s07, AppSpacing.s07, AppSpacing.s07, AppSpacing.s10),
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
                      SizedBox(height: AppSpacing.s07),

                      // Years of Experience
                      Text(translate(context, "editProfile.yearsOfExperience"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.s04),
                      GestureDetector(
                        onTap: () => _showYearsOfExperienceBottomSheet(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
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
                                  _yearsOfExperience,
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
                      SizedBox(height: AppSpacing.s10),

                      // Work & social links
                      Text(translate(context, "editProfile.workSocialLinks"),
                          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase)
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: AppSpacing.s06),
                      _LinkField(
                        icon: AssetsPath.githubSvg,
                        controller: _githubController,
                        hint: translate(context, "editProfile.githubHint"),
                      ),
                      SizedBox(height: AppSpacing.s06),
                      _LinkField(
                        icon: AssetsPath.linkedinSvg,
                        controller: _linkedInController,
                        hint: translate(context, "editProfile.linkedinHint"),
                      ),
                      SizedBox(height: AppSpacing.s06),
                      _LinkField(
                        icon: AssetsPath.websiteSvg,
                        controller: _websiteController,
                        hint: translate(context, "editProfile.websiteHint"),
                      ),

                      SizedBox(height: AppSpacing.s10),
                      Center(
                        child: Padding(
                          padding: AppSpacing.horizontal(AppSpacing.s05),
                          child: Text(
                            translate(context, "editProfile.privacyDisclaimer"),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.s10),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: GradientButton(
                              isLoading: false,
                              // onTap: () => _submit(context),
                              onTap: (){},
                              text: translate(context, "editProfile.submit"),
                              textStyle: AppTextStyles.bodyLarge.copyWith(color: AppBorders.tertiary),
                              height: 50.h,
                              width: double.infinity,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                translate(context, "editProfile.cancel"),
                                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.blackBase),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.s10),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showSuccessOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: AppColors.blackBase.withOpacity(0.7),
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
        margin: AppSpacing.all07,
        padding: AppSpacing.vertical(AppSpacing.s06),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: AppRadius.all06,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(height: AppSpacing.s03),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item == selectedValue;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSelected(item);
              },
              child: Container(
                margin: AppSpacing.horizontal(AppSpacing.s06),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.s07,
                  vertical: AppSpacing.s07,
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
              EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
          prefixIcon: Padding(
            padding: AppSpacing.all06,
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
