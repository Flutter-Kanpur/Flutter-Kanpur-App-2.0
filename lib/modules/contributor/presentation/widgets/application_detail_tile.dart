import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ApplicationDetailTile extends StatelessWidget {
  const ApplicationDetailTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.vertical(AppSpacing.v10),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
