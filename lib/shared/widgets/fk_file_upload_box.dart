import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';

class FkFileUploadBox extends StatelessWidget {
  const FkFileUploadBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.symmetric(
        horizontal: AppSpacing.h16,
        vertical: AppSpacing.v20,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteBase,
        borderRadius: AppRadius.all04,
        border: Border.all(color: AppBorders.primary, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_upload_outlined, color: AppColors.neutral400),
          SizedBox(height: AppSpacing.v10),
          Text(
            'Choose a file or drag & drop it here.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.v12),
          OutlinedButton(onPressed: () {}, child: const Text('Browse files')),
        ],
      ),
    );
  }
}
