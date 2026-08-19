import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';

/// Centered "Projects" title + back arrow, shared by the projects list and
/// a project's detail screen. `FkHeader` is always left-aligned with an
/// optional subtitle, so this is its own small widget instead.
class ProjectsAppBar extends StatelessWidget {
  const ProjectsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h20,
        vertical: AppSpacing.v8,
      ),
      child: Row(
        children: [
          const FkBackButton(),
          Expanded(
            child: Text(
              'Projects',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Balances the back button so the title is visually centered.
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
