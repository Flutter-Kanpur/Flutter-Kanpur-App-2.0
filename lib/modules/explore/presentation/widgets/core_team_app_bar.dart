import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';

class CoreTeamAppBar extends StatelessWidget {
  const CoreTeamAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.h10,
        vertical: AppSpacing.v8,
      ),
      child: Row(
        children: [
          const FkBackButton(),
          Expanded(
            child: Text(
              'Core team',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.blackBase,

              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
