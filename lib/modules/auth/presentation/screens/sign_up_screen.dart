import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/core/constants/app_assets.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/custom_textfield.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  final _usernameFieldKey = GlobalKey();
  final _emailFieldKey = GlobalKey();
  final _passwordFieldKey = GlobalKey();
  final _confirmPasswordFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    for (final node in [
      _usernameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode,
    ]) {
      node.addListener(_scrollToFocused);
    }
  }

  void _scrollToFocused() {
    final nodes = [
      _usernameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode,
    ];
    final keys = [
      _usernameFieldKey,
      _emailFieldKey,
      _passwordFieldKey,
      _confirmPasswordFieldKey,
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

  @override
  void dispose() {
    for (final node in [
      _usernameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _confirmPasswordFocusNode,
    ]) {
      node
        ..removeListener(_scrollToFocused)
        ..dispose();
    }
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).signUpWithEmail(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AppAuthState>(authNotifierProvider, (_, next) {
      if (!context.mounted) return;
      if (next.status == AuthStatus.verificationSent) {
        context.go(RouteNames.emailVerification);
      } else if (next.status == AuthStatus.authenticated) {
        context.go(RouteNames.home);
      }
    });

    return GradientBackground(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24.sp,
                right: 24.sp,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        110.verticalSpace,
                        _buildMascot(),
                        18.verticalSpace,
                        _buildHeaderText(),
                        35.verticalSpace,

                        if (authState.error != null) ...[
                          _ErrorBanner(message: authState.error!),
                          16.verticalSpace,
                        ],

                        _buildField(
                          fieldKey: _usernameFieldKey,
                          text: 'auth.username'.tr(),
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'auth.usernameRequired'.tr()
                              : null,
                        ),
                        12.verticalSpace,
                        _buildField(
                          fieldKey: _emailFieldKey,
                          text: 'auth.emailAddress'.tr(),
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'auth.emailRequired'.tr() : null,
                        ),
                        12.verticalSpace,
                        _buildField(
                          fieldKey: _passwordFieldKey,
                          text: 'auth.createPassword'.tr(),
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          isPassword: true,
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'auth.passwordRequired'.tr() : null,
                        ),
                        12.verticalSpace,
                        _buildField(
                          fieldKey: _confirmPasswordFieldKey,
                          text: 'auth.confirmPassword'.tr(),
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          isPassword: true,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'auth.confirmPasswordRequired'.tr();
                            }
                            if (v != _passwordController.text) {
                              return 'auth.passwordsDoNotMatch'.tr();
                            }
                            return null;
                          },
                        ),

                        35.verticalSpace,

                        GradientButton(
                          height: 45.h,
                          text: authState.isLoading
                              ? 'auth.loading'.tr()
                              : 'auth.createAccountButton'.tr(),
                          textStyle:
                              textStyle_16RegularBlack().copyWith(color: Colors.white),
                          onTap: authState.isLoading ? () {} : _submit,
                        ),

                        20.verticalSpace,

                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: '${'auth.alreadyHaveAccount'.tr()} ',
                              style: textStyle_14RegularBlack(),
                              children: [
                                TextSpan(
                                  text: 'auth.loginNow'.tr(),
                                  style: textStyle_14RegularBlack().copyWith(
                                    color: AppColors.selectedNavBarIconColor,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.go(RouteNames.signIn),
                                ),
                              ],
                            ),
                          ),
                        ),

                        8.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Image.asset(AppAssets.dashIcon, fit: BoxFit.contain),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: [
        Text(
          'auth.signUpTitle'.tr(),
          style: textStyle_18MediumBlack().copyWith(fontSize: 24.sp),
        ),
        18.verticalSpace,
        Text(
          'auth.signUpSubTitle'.tr(),
          textAlign: TextAlign.center,
          style: textStyle_16RegularBlack().copyWith(color: AppColors.subtitleTextDarkGrey),
        ),
      ],
    );
  }

  Widget _buildField({
    required GlobalKey fieldKey,
    required String text,
    required TextEditingController controller,
    required FocusNode focusNode,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      key: fieldKey,
      child: CustomTextField(
        text: text,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        isPassword: isPassword,
        showBorder: focusNode.hasFocus || controller.text.isNotEmpty,
        borderColor: focusNode.hasFocus
            ? AppColors.selectedNavBarIconColor
            : controller.text.isNotEmpty
                ? AppColors.communityBorderColor
                : const Color(0xFFF6F6F6),
        fillColor: focusNode.hasFocus || controller.text.isNotEmpty
            ? Colors.transparent
            : const Color(0xFFF6F6F6),
        validator: validator,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: textStyle_14RegularBlack().copyWith(color: Colors.red.shade700),
        textAlign: TextAlign.center,
      ),
    );
  }
}
