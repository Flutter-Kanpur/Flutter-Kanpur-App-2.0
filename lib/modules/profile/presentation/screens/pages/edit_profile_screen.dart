import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../../utils/assets_path.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/translate.dart';

import '../../../../../shared/widgets/gradiant_background.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/text_styles.dart';

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
  bool _initialized = false;

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

  void _prefillFromProfile( profile, String? authEmail) {
    if (_initialized || profile == null) return;
    if (profile.fullName == null &&
        profile.about == null &&
        profile.github == null) {}

    _initialized = true;
    final emailPrefix = authEmail?.split('@').first ?? '';

    _usernameController.text = profile.fullName ?? '';

    _aboutController.text = profile.about ?? '';

    _githubController.text = profile.github ?? 'github.com/$emailPrefix';
    _linkedInController.text =
        profile.linkedin ?? 'linkedin.com/in/$emailPrefix';
    _websiteController.text = profile.website ?? '';

    _yearsOfExperience = profile.yearsOfExperience ?? '0-1 years';
  }

  InputDecoration _decoration(String hint, {Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: textStyle_hintText(),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.communityBorderColorV2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.communityBorderColorV2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.selectedNavBarIconColor),
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
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(35.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.r),
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
                  style: textStyle_18BlackRegular(),
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
                  style: textStyle_18BlackRegular(),
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
                  style: textStyle_18RedRegular(),
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
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 28.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(translate(context, "editProfile.removePhoto"),
                    style: textStyle_24BlackBold()),
                12.verticalSpace,
                Text(
                  translate(context, "editProfile.removeConfirmation"),
                  textAlign: TextAlign.center,
                  style: textStyle_16RegularGrey(),
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
                      color: AppColors.redBgText,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Text(
                      translate(context, "editProfile.delete"),
                      style: textStyle_16RegularWhite(),
                    ),
                  ),
                ),
                14.verticalSpace,
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(translate(context, "editProfile.cancel"),
                      style: textStyle_16RedRegular()),
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
                size: 24.sp, color: const Color(0xFF000000)),
          ),
          title: Text(
            translate(context, "editProfile.title"),
            style: textStyle_20BlackMedium(),
          ),
        ),
        body: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: AppColors.communityBorderColorV2,
                          ),
                        ),
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 35.r,
                                backgroundColor:
                                    AppColors.avatarBackgroundColor,
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
                                        style: textStyle_20BlackMedium(),
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: textStyle_24BoldBlack()
                                        .copyWith(fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 4.h),
                                  GestureDetector(
                                    onTap: _showImagePickerSheet,
                                    child: Text(
                                      translate(
                                          context, "editProfile.changePhoto"),
                                      style: textStyle_14RegularLinkBlue(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Username
                      Text(translate(context, "editProfile.username"),
                          style: textStyle_16RegularBlack()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _usernameController,
                        style: textStyle_16MediumBlack(),
                        decoration: _decoration(
                            translate(context, "editProfile.username")),
                      ),
                      SizedBox(height: 24.h),

                      // About me
                      Text(translate(context, "editProfile.aboutMe"),
                          style: textStyle_16RegularBlack()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      Stack(
                        children: [
                          TextFormField(
                            controller: _aboutController,
                            maxLines: 4,
                            maxLength: _aboutMaxLength,
                            style: textStyle_16MediumBlack(),
                            onChanged: (_) => setState(() {}),
                            decoration: _decoration(
                                    translate(context, "editProfile.addBio"))
                                .copyWith(
                              counterText: '',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 30.h),
                            ),
                          ),
                          Positioned(
                            bottom: 8.h,
                            right: 16.w,
                            child: Text(
                              '${_aboutController.text.length}/$_aboutMaxLength',
                              style: textStyle_12RegularGrey(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Years of Experience
                      Text(translate(context, "editProfile.yearsOfExperience"),
                          style: textStyle_16RegularBlack()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => _showYearsOfExperienceBottomSheet(context),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.communityBorderColorV2),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _yearsOfExperience,
                                  style: textStyle_16MediumBlack(),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 24.sp,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Work & social links
                      Text(translate(context, "editProfile.workSocialLinks"),
                          style: textStyle_16RegularBlack()
                              .copyWith(fontWeight: FontWeight.w500)),
                      SizedBox(height: 12.h),
                      _LinkField(
                        icon: AssetsPath.githubSvg,
                        controller: _githubController,
                        hint: translate(context, "editProfile.githubHint"),
                      ),
                      SizedBox(height: 12.h),
                      _LinkField(
                        icon: AssetsPath.linkedinSvg,
                        controller: _linkedInController,
                        hint: translate(context, "editProfile.linkedinHint"),
                      ),
                      SizedBox(height: 12.h),
                      _LinkField(
                        icon: AssetsPath.websiteSvg,
                        controller: _websiteController,
                        hint: translate(context, "editProfile.websiteHint"),
                      ),

                      SizedBox(height: 24.h),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            translate(context, "editProfile.privacyDisclaimer"),
                            textAlign: TextAlign.center,
                            style: textStyle_14FooterText(),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

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
                              textStyle: textStyle_16RegularWhite(),
                              height: 50.h,
                              width: double.infinity,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => context.pop(),
                              child: Text(
                                translate(context, "editProfile.cancel"),
                                style: textStyle_16RegularBlack(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
          ),
    );
  }

  void _showSuccessOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item == selectedValue;

            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onSelected(item);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFE2E6F3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item,
                      style: textStyle_16MediumBlack(),
                    ),
                    if (isSelected)
                      const Icon(Icons.check,
                          size: 20, color: AppColors.primary),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.communityBorderColorV2),
      ),
      child: TextFormField(
        controller: controller,
        style: textStyle_16MediumBlack(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: textStyle_hintText(),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              icon,
              height: 20.sp,
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
