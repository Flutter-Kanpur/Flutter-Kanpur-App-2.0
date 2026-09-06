import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/app_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/navigation_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_session_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/modules/profile/application/profile_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

/// Root widget: invalidates session-scoped providers when the signed-in user changes.
class FlutterKanpurApp extends ConsumerWidget {
  const FlutterKanpurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authUserIdProvider, (previous, next) {
      if (previous?.value != next.value) {
        ref.invalidate(currentUserProvider);
        ref.invalidate(myProfileProvider);
        ref.invalidate(nextRouteProvider);
      }
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Kanpur',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: AppTextStyles.fontFamily,
            textTheme: AppTextStyles.textTheme,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary600),
            scaffoldBackgroundColor: AppColors.whiteBase,
          ),
        );
      },
    );
  }
}
