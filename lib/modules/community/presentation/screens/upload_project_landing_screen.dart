import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class UploadProjectLandingScreen extends StatelessWidget {
  const UploadProjectLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkScreen(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => context.go(RouteNames.community),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        SizedBox(height: AppSpacing.s10),
        Text(
          'Showcase your work and inspire other community members.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        SizedBox(height: AppSpacing.s10),
        const _TimelineStep(
          title: 'Submit your project',
          body:
              'Share your project details, tech stack, and relevant links for review.',
          isFirst: true,
        ),
        const _TimelineStep(
          title: 'Review by the community team',
          body:
              'Our team reviews submissions to ensure relevance and community value.',
        ),
        const _TimelineStep(
          title: 'Approved and published',
          body:
              'Once approved, your project is published and visible to the community.',
          isLast: true,
        ),
        SizedBox(height: AppSpacing.s10),
        Container(
          padding: AppSpacing.all10,
          decoration: BoxDecoration(
            color: AppColors.primary50,
            borderRadius: AppRadius.all04,
          ),
          child: Column(
            children: [
              Text(
                'Ready to share your project?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              SizedBox(height: AppSpacing.s05),
              const Text(
                'Upload your project and let the community inspired by your work.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.s08),
              SizedBox(
                width: 200,
                child: FkPrimaryButton(
                  label: 'Upload project',
                  icon: null,
                  onPressed: () =>
                      context.go(RouteNames.communityUploadProjectForm),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.body,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final String body;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.whiteBase, size: 18),
              ),
              if (!isLast)
                Expanded(child: Container(width: AppSpacing.s03, color: AppColors.primary500)),
            ],
          ),
          SizedBox(width: AppSpacing.s07),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.s10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.s03),
                  Text(body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
