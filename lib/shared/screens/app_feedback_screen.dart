import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_result_screen.dart';

class AppFeedbackScreen extends StatelessWidget {
  const AppFeedbackScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    this.buttonIcon,
    this.secondaryText,
    this.onSecondaryPressed,
    this.isSuccess = true,
  });

  final String image;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? buttonIcon;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;
  final bool isSuccess;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.whiteBase,
    body: FkResultScreen(
      title: title,
      message: subtitle,
      icon: isSuccess
          ? Icons.check_rounded
          : Icons.wifi_tethering_error_rounded,
      color: isSuccess ? AppColors.primary500 : AppColors.warning600,
      imageAsset: image,
      buttonIcon: buttonIcon,
      buttonLabel: buttonText,
      onPressed: onPressed,
      secondaryLabel: secondaryText,
      onSecondaryPressed: onSecondaryPressed,
    ),
  );
}
}