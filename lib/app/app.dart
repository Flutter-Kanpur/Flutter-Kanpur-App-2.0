import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/app_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class FlutterKanpurApp extends StatelessWidget {
  const FlutterKanpurApp({super.key});

  @override
  Widget build(BuildContext context) {
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
