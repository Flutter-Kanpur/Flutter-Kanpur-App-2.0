import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/custom_textfield.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s05),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                  ),
                ),
                80.verticalSpace,
                _buildMascot(),
                40.verticalSpace,
                _buildHeaderText(),
                45.verticalSpace,
                _buildEmailField(emailController),
                18.verticalSpace,
                _buildPasswordField(passwordController),
                70.verticalSpace,
                _buildSignInButton(
                  context,
                  ref,
                  formKey,
                  emailController,
                  passwordController,
                  isLoading,
                ),
                24.verticalSpace,
                _buildSignUpText(context),
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
      child: Image.asset(AppAssets.dashIcon, fit: BoxFit.contain),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          'auth.welcomeBack'.tr(),
          style: AppTextStyles.titleLarge.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.w700),
        ),
        14.verticalSpace,
        Padding(
          padding: AppSpacing.horizontal(AppSpacing.s07),
          child: Text(
            'auth.welcomeBackSubTitle'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(TextEditingController controller) {
    return CustomTextField(
      text: 'auth.emailAddress'.tr(),
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      showBorder: true,
      borderColor: AppColors.neutral100,
      fillColor: AppColors.neutral50,
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
      borderColor: AppColors.neutral100,
      fillColor: AppColors.neutral50,
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

  Widget _buildSignInButton(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isLoading,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: GradientButton(
        text: isLoading ? 'auth.signingIn'.tr() : 'auth.login'.tr(),
        textStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.whiteBase,
          fontWeight: FontWeight.w600,
        ),
        onTap: isLoading
            ? () {}
            : () async {
                if (!formKey.currentState!.validate()) return;
                FocusScope.of(context).unfocus();

                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                final ctx = context;

                setState(() => isLoading = true);

                try {
                  await ref.read(signInProvider)(
                    email: email,
                    password: password,
                  );
                  if (mounted) {
                    _showToast(
                      ctx,
                      'auth.signin_success'.tr(),
                      AppColors.success600,
                      Icons.check_circle,
                    );
                    Future.delayed(const Duration(milliseconds: 800)).then((_) {
                      if (mounted) {
                        ctx.pushReplacement(RouteNames.home);
                      }
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    _showToast(
                      ctx,
                      e.toString(),
                      AppColors.warning600,
                      Icons.error,
                    );
                    setState(() => isLoading = false);
                  }
                }
              },
      ),
    );
  }

  Widget _buildSignUpText(BuildContext context) {
    return Padding(
      padding: AppSpacing.horizontal(AppSpacing.s07),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: '${'auth.dontHaveAccount'.tr()} ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
            children: [
              TextSpan(
                text: 'auth.signUpNow'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w700,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => context.pushReplacement(RouteNames.signUp),
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
            Icon(icon, color: AppColors.whiteBase, size: 20.sp),
            12.horizontalSpace,
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.whiteBase),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: AppSpacing.all07,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.all02,
        ),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.s07, vertical: AppSpacing.s07),
      ),
    );
  }
}
