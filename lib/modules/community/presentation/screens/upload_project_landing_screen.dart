import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_primary_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/utils/colors.dart';
import 'package:go_router/go_router.dart';

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
        const SizedBox(height: 26),
        Text(
          'Showcase your work and inspire other community members.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 40),
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
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.communityGuidelinesContainerBackground,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Text(
                'Ready to share your project?',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload your project and let the community inspired by your work.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
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
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 18),
              ),
              if (!isLast)
                Expanded(child: Container(width: 3, color: AppColors.primary)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
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
