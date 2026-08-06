import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class FkResultScreen extends StatelessWidget {
  const FkResultScreen({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.all(AppSpacing.h22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 132,
              height: 132,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.65), color],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.24),
                    blurRadius: 24,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Icon(icon, size: 70, color: AppColors.whiteBase),
            ),
            SizedBox(height: AppSpacing.v22),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.v22),
            SizedBox(
              width: 220,
              child: OutlinedButton(
                onPressed: onPressed,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
