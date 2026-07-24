import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kanpur_ui_kit/flutter_kanpur_ui_kit.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradient_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class AuthLandingScreen extends StatefulWidget {
  const AuthLandingScreen({super.key});

  @override
  State<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends State<AuthLandingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<AuthLandingScreenData> get pages => [
    AuthLandingScreenData(
      title: 'authLanding.screen1Title'.tr(),
      description: 'authLanding.screen1SubTitle'.tr(),
    ),

    AuthLandingScreenData(
      title: 'authLanding.screen2Title'.tr(),
      description: 'authLanding.screen2SubTitle'.tr(),
    ),

    AuthLandingScreenData(
      title: 'authLanding.screen3Title'.tr(),
      description: 'authLanding.screen3SubTitle'.tr(),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (!mounted) return;
      context.go(RouteNames.authOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.all09,
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    context.go(RouteNames.authOptions);
                  },
                  child: Text('Skip', style: AppTextStyles.titleMedium.copyWith(color: AppColors.blackBase)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              ),
            ),
            Padding(
              padding: AppSpacing.all09,
              child: Column(
                children: [
                  _buildPageIndicators(),
                  32.verticalSpace,
                  _buildNextButton(),
                  27.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(AuthLandingScreenData pageData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 3),

          Text(
            pageData.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.blackBase, fontWeight: FontWeight.bold),
          ),
          16.verticalSpace,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.s05),
            child: Text(
              pageData.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral500, fontWeight: FontWeight.w300, height: 1.5),
            ),
          ),
          1.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.s01),
          width: _currentPage == index ? 32.w : 8.w,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.blackBase : AppColors.neutral200,
            borderRadius: AppRadius.all01,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GradientButton(
      textStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.whiteBase,
      ),
      width: 150.w,
      onTap: _goToNextPage,
      text: _currentPage == pages.length - 1 ? 'Get Started ->' : 'Next ->',
    );
  }
}

class AuthLandingScreenData {
  final String title;
  final String description;

  AuthLandingScreenData({required this.title, required this.description});
}
