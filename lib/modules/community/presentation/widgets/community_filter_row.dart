import 'package:flutter/material.dart';

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
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? primary : const Color(0xFFD8DDF0),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: selected ? primary : null),
              const SizedBox(width: 6),
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
