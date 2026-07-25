import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';

class CommunityFilterRow extends StatelessWidget {
  const CommunityFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String? selected;
  final ValueChanged<String?> onSelected;

  static const _filters = ['Trending', 'Active', 'Unanswered'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: 'Filters',
            icon: Icons.filter_list_rounded,
            selected: false,
            onTap: () {},
          ),
          ..._filters.map(
            (f) => _Chip(
              label: f,
              selected: selected == f,
              onTap: () => onSelected(selected == f ? null : f),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.h8),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.1) : AppColors.whiteBase,
          borderRadius: AppRadius.all02,
          border: Border.all(
            color: selected ? primary : AppColors.primary100,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: selected ? primary : null),
              SizedBox(width: AppSpacing.h6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? primary : null,
                  ),
            ),
            if (icon != null)
              Icon(Icons.keyboard_arrow_down, size: 18,
                  color: selected ? primary : null),
          ],
        ),
      ),
    );
  }
}
