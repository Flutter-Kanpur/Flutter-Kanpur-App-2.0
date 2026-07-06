import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/custom_textfield.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final signUpState = ref.watch(signUpControllerProvider);

    ref.listen(signUpControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          _showToast(
            context,
            'auth.signup_success'.tr(),
            Colors.green.shade600,
            Icons.check_circle,
          );
          Future.delayed(const Duration(milliseconds: 800)).then((_) {
            if (context.mounted) {
              context.go(RouteNames.signIn);
            }
          });
        },
        error: (error, stackTrace) {
          _showToast(
            context,
            error.toString(),
            Colors.red.shade600,
            Icons.error,
          );
        },
        loading: () {},
      );
    });

    return GradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                80.verticalSpace,
                _buildMascot(),
                30.verticalSpace,
                _buildHeaderText(),
                35.verticalSpace,
                _buildUsernameField(usernameController),
                16.verticalSpace,
                _buildEmailField(emailController),
                16.verticalSpace,
                _buildPasswordField(passwordController),
                16.verticalSpace,
                _buildConfirmPasswordField(
                  confirmPasswordController,
                  passwordController,
                ),
                50.verticalSpace,
                _buildCreateButton(
                  context,
                  ref,
                  formKey,
                  usernameController,
                  emailController,
                  passwordController,
                  signUpState.isLoading,
                ),
                20.verticalSpace,
                _buildSignInText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return SizedBox(
      width: 110.w,
      height: 110.w,
      child: Image.asset(
        AppAssets.dashIcon,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          'auth.signUpTitle'.tr(),
          style: textStyle_18MediumBlack().copyWith(
            fontSize: 26.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        14.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'auth.signUpSubTitle'.tr(),
            textAlign: TextAlign.center,
            style: textStyle_14RegularBlack().copyWith(
              color: AppColors.subtitleTextDarkGrey,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField(TextEditingController controller) {
    return CustomTextField(
      text: 'auth.username'.tr(),
      controller: controller,
      showBorder: true,
      borderColor: AppColors.communityBorderColor,
      fillColor: const Color(0xFFF6F6F6),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'auth.usernameRequired'.tr();
        }
        if (value.length < 3) {
          return 'auth.usernameMin3'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return CustomTextField(
      text: 'auth.emailAddress'.tr(),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      showBorder: true,
      borderColor: AppColors.communityBorderColor,
      fillColor: const Color(0xFFF6F6F6),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'auth.emailRequired'.tr();
        }
        if (!value.contains('@')) {
          return 'auth.invalidEmail'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller) {
    return CustomTextField(
      text: 'auth.password'.tr(),
      controller: controller,
      isPassword: true,
      showBorder: true,
      borderColor: AppColors.communityBorderColor,
      fillColor: const Color(0xFFF6F6F6),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'auth.passwordRequired'.tr();
        }
        if (value.length < 6) {
          return 'auth.passwordMin6'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField(
    TextEditingController controller,
    TextEditingController passwordController,
  ) {
    return CustomTextField(
      text: 'auth.confirmPassword'.tr(),
      controller: controller,
      isPassword: true,
      showBorder: true,
      borderColor: AppColors.communityBorderColor,
      fillColor: const Color(0xFFF6F6F6),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'auth.confirmPasswordRequired'.tr();
        }
        if (value != passwordController.text) {
          return 'auth.passwordsDoNotMatch'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildCreateButton(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController usernameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: GradientButton(
        text: isLoading ? 'auth.creatingAccount'.tr() : 'auth.createAccount'.tr(),
        textStyle: textStyle_16RegularBlack().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        onTap: isLoading
            ? () {}
            : () {
                if (!formKey.currentState!.validate()) return;
                FocusScope.of(context).unfocus();

                final username = usernameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                ref.read(signUpControllerProvider.notifier).signUp(
                      email: email,
                      password: password,
                      displayName: username,
                    );
              },
      ),
    );
  }

  Widget _buildSignInText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: '${'auth.alreadyHaveAccount'.tr()} ',
            style: textStyle_14RegularBlack().copyWith(
              color: AppColors.subtitleTextDarkGrey,
            ),
            children: [
              TextSpan(
                text: 'auth.login'.tr(),
                style: textStyle_14RegularBlack().copyWith(
                  color: AppColors.selectedNavBarIconColor,
                  fontWeight: FontWeight.w700,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => context.go(RouteNames.signIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(
    BuildContext context,
    String message,
    Color bgColor,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.sp),
            12.horizontalSpace,
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
