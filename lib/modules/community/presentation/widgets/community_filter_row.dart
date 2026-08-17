import 'package:flutter/material.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/data/repositories/community_repository.dart';

/// Horizontal filter chips above the discussions list.
///
/// Emits [CommunityFilter] identifiers, not display labels — the previous
/// version emitted "Trending" / "Active" / "Unanswered", none of which the
/// repository recognised, so tapping a chip quietly did nothing.
class CommunityFilterRow extends StatelessWidget {
  const CommunityFilterRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String? selected;
  final ValueChanged<String?> onSelected;

  /// Chips shown inline; the rest live behind the "Filters" sheet.
  static const _inlineFilters = [
    CommunityFilter.trending,
    CommunityFilter.active,
    CommunityFilter.unanswered,
  ];

  Future<void> _openFilterSheet(BuildContext context) async {
    final picked = await showModalBottomSheet<String?>(
      context: context,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r04)),
      ),
      builder: (sheetContext) => SafeArea(
        child: RadioGroup<String?>(
          groupValue: selected,
          onChanged: (value) => Navigator.pop(sheetContext, value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final filter in CommunityFilter.all)
                RadioListTile<String?>(
                  value: filter,
                  title: Text(CommunityFilter.labelOf(filter)),
                ),
              const RadioListTile<String?>(
                value: null,
                title: Text('All discussions'),
              ),
              SizedBox(height: AppSpacing.v12),
            ],
          ),
        ),
      ),
    );

    // A dismissed sheet returns null too, so only apply when it really closed
    // with a choice.
    if (!context.mounted) return;
    if (picked != selected) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: 'Filters',
            icon: Icons.filter_list_rounded,
            showChevron: true,
            // Highlighted when a filter that has no inline chip is active.
            selected:
                selected != null && !_inlineFilters.contains(selected),
            onTap: () => _openFilterSheet(context),
          ),
          ..._inlineFilters.map(
            (f) => _Chip(
              label: CommunityFilter.labelOf(f),
              selected: selected == f,
              // Tapping the active chip clears it.
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
    this.showChevron = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary500;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.h8),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.1)
              : AppColors.whiteBase,
          borderRadius: AppRadius.all02,
          border: Border.all(color: selected ? primary : AppColors.primary100),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? primary : AppColors.neutral600,
              ),
              SizedBox(width: AppSpacing.h6),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? primary : AppColors.neutral800,
              ),
            ),
            if (showChevron)
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: selected ? primary : AppColors.neutral600,
              ),
          ],
        ),
      ),
    );
  }
}
