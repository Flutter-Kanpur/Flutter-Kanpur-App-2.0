import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class CommunityContributeCard extends StatelessWidget {
  const CommunityContributeCard({
    super.key,
    required this.label,
    required this.body,
    required this.onTap,
    this.title,
  });

  final String label;
  final String? title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD9E0FF)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
            if (title != null) ...[
              const SizedBox(height: 16),
              Text(
                title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                body,
                overflow: TextOverflow.ellipsis,
                maxLines: title == null ? 4 : 5,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.36,
                      color: title == null
                          ? Colors.black
                          : AppColors.subtitleTextDarkGrey,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
