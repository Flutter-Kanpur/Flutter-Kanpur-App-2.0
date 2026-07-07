import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterBottomSheet extends StatelessWidget {
  final String? activeFilter;
  final Function(String?) onFilterChanged;

  const FilterBottomSheet({
    super.key,
    this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Discussions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          _FilterOption(
            title: 'All',
            icon: Icons.list,
            selected: activeFilter == null,
            onTap: () {
              onFilterChanged(null);
              Navigator.pop(context);
            },
          ),
          _FilterOption(
            title: 'My Questions',
            icon: Icons.person,
            selected: activeFilter == 'my_questions',
            onTap: () {
              onFilterChanged('my_questions');
              Navigator.pop(context);
            },
          ),
          _FilterOption(
            title: 'Unanswered',
            icon: Icons.help_outline,
            selected: activeFilter == 'unanswered',
            onTap: () {
              onFilterChanged('unanswered');
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Colors.blue : Colors.grey,
      ),
      title: Text(title),
      trailing: selected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      onTap: onTap,
      selected: selected,
    );
  }
}
