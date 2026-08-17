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
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/services/user_service.dart';

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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _emailFieldKey = GlobalKey();
  final _passwordFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    _emailFocusNode.addListener(_onFieldChanged);
    _passwordFocusNode.addListener(_onFieldChanged);

    emailController.addListener(_onFieldChanged);
    passwordController.addListener(_onFieldChanged);

    formKey = GlobalKey<FormState>();
  }


  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(_onFieldChanged);
    _passwordFocusNode.removeListener(_onFieldChanged);

    emailController.removeListener(_onFieldChanged);
    passwordController.removeListener(_onFieldChanged);

    emailController.dispose();
    passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              padding: EdgeInsets.zero,
            ),
          ),
          body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildMascot(),
                40.verticalSpace,
                _buildHeaderText(),
                45.verticalSpace,
                _buildEmailField(controller: emailController, focusNode: _emailFocusNode),
                10.verticalSpace,
                _buildPasswordField(controller: passwordController, focusNode : _passwordFocusNode),
                40.verticalSpace,
                _buildSignInButton(
                  context,
                  ref,
                  formKey,
                  emailController,
                  passwordController,
                ),
                24.verticalSpace,
                _buildSignUpText(context),
                20.verticalSpace,
              ],
            ),
          ),
        ),
      ),
        ));
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
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.blackBase,
          ),
        ),
        14.verticalSpace,
        Padding(
          padding: AppSpacing.horizontal(AppSpacing.h16),
          child: Text(
            'auth.welcomeBackSubTitle'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField({required TextEditingController controller,required FocusNode focusNode }) {
    return CustomTextField(
      key: _emailFieldKey,
      text: 'auth.emailAddress'.tr(),
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      showTickIcon: controller.text.isNotEmpty && (focusNode.hasFocus == false),
      // showBorder:
      // focusNode.hasFocus || controller.text.isNotEmpty,
      // borderColor: focusNode.hasFocus
      //     ? AppColors.primary500
      //     : controller.text.isNotEmpty
      //     ? AppColors.whiteBase
      //     : const Color(0xFFF6F6F6),
      // fillColor: focusNode.hasFocus || controller.text.isNotEmpty
      //     ? Colors.transparent
      //     : const Color(0xFFF6F6F6),
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

  Widget _buildPasswordField({required TextEditingController controller,required FocusNode focusNode}) {

    return CustomTextField(
      key: _passwordFieldKey,
      text: 'auth.password'.tr(),
      controller: controller,
      focusNode: focusNode,
      isPassword: true,
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
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: GradientButton(
        text: this.isLoading ? 'auth.signingIn'.tr() : 'auth.login'.tr(),
        textStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.whiteBase,
          fontWeight: FontWeight.w600,
        ),
        onTap: this.isLoading
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
                    await Future.delayed(const Duration(milliseconds: 800));
                    if (!mounted) return;
                    final done = await UserService().isOnboardingCompleted();
                    if (!mounted) return;
                    ctx.pushReplacement(
                      done
                          ? RouteNames.home
                          : RouteNames.onboardingNavigation,
                    );
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
      padding: AppSpacing.horizontal(AppSpacing.h16),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: '${'auth.dontHaveAccount'.tr()} ',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.neutral500,
            ),
            children: [
              TextSpan(
                text: 'auth.createAccountNow'.tr(),
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary500,
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
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.whiteBase,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: bgColor,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: AppSpacing.all(AppSpacing.h16),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.all02),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.h16,
          vertical: AppSpacing.v16,
        ),
      ),
    );
  }
}
