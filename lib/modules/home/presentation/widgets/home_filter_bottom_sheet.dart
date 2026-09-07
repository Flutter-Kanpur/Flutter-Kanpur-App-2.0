import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_text_styles.dart';
import 'package:flutter_knp_mobile_app_v2/modules/home/presentation/widgets/filter_section.dart';

class HomeFilterBottomSheet extends StatefulWidget {
  const HomeFilterBottomSheet({super.key, this.initialFilters = const {}});

  final Map<String, Set<String>> initialFilters;

  static Future<Map<String, Set<String>>?> show(
    BuildContext context, {
    Map<String, Set<String>> initialFilters = const {},
  }) {
    return showModalBottomSheet<Map<String, Set<String>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (_) {
        return HomeFilterBottomSheet(initialFilters: initialFilters);
      },
    );
  }

  @override
  State<HomeFilterBottomSheet> createState() => _HomeFilterBottomSheetState();
}

class _HomeFilterBottomSheetState extends State<HomeFilterBottomSheet> {
  late final Map<String, Set<String>> _selectedFilters;

  @override
  void initState() {
    super.initState();

    _selectedFilters = {
      'Status-based': {
        ...(widget.initialFilters['Status-based'] ?? <String>{}),
      },
      'Mode / Format': {
        ...(widget.initialFilters['Mode / Format'] ?? <String>{}),
      },
      'Time-based': {...(widget.initialFilters['Time-based'] ?? <String>{})},
      'Access': {...(widget.initialFilters['Access'] ?? <String>{})},
      'Interest / Type': {
        ...(widget.initialFilters['Interest / Type'] ?? <String>{}),
      },
    };
  }

  void _toggleOption(String section, String option) {
    setState(() {
      final selectedOptions = _selectedFilters[section]!;

      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (final filters in _selectedFilters.values) {
        filters.clear();
      }
    });
  }

  int get _selectedCount {
    return _selectedFilters.values.fold(
      0,
      (total, filters) => total + filters.length,
    );
  }

  void _applyFilters() {
    final result = <String, Set<String>>{};

    for (final entry in _selectedFilters.entries) {
      if (entry.value.isNotEmpty) {
        result[entry.key] = Set<String>.from(entry.value);
      }
    }

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 8.w, right: 8.w),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteBase,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag handle
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.blackBase,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 12.w, 6.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'home.filters.title'.tr(),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.blackBase,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.h,
                      decoration: const BoxDecoration(
                        color: AppColors.blackBase,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 17.sp,
                        color: AppColors.whiteBase,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: AppColors.neutral200),

            // Filter content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FilterSection(
                      title: 'home.filters.sections.statusBased.title'.tr(),
                      options: [
                        'home.filters.sections.statusBased.options.upcoming'
                            .tr(),
                        'home.filters.sections.statusBased.options.live'.tr(),
                        'home.filters.sections.statusBased.options.today'.tr(),
                        'home.filters.sections.statusBased.options.past'.tr(),
                      ],
                      selectedOptions: _selectedFilters['Status-based']!,
                      onOptionSelected: (value) {
                        _toggleOption('Status-based', value);
                      },
                    ),

                    FilterSection(
                      title: 'home.filters.sections.modeFormat.title'.tr(),
                      options: [
                        'home.filters.sections.modeFormat.options.online'.tr(),
                        'home.filters.sections.modeFormat.options.offline'.tr(),
                      ],
                      selectedOptions: _selectedFilters['Mode / Format']!,
                      onOptionSelected: (value) {
                        _toggleOption('Mode / Format', value);
                      },
                    ),

                    FilterSection(
                      title: 'home.filters.sections.timeBased.title'.tr(),
                      options: [
                        'home.filters.sections.timeBased.options.thisWeek'.tr(),
                        'home.filters.sections.timeBased.options.thisMonth'
                            .tr(),
                      ],
                      selectedOptions: _selectedFilters['Time-based']!,
                      onOptionSelected: (value) {
                        _toggleOption('Time-based', value);
                      },
                    ),

                    FilterSection(
                      title: 'home.filters.sections.access.title'.tr(),
                      options: [
                        'home.filters.sections.access.options.free'.tr(),
                        'home.filters.sections.access.options.openToAll'.tr(),
                      ],
                      selectedOptions: _selectedFilters['Access']!,
                      onOptionSelected: (value) {
                        _toggleOption('Access', value);
                      },
                    ),

                    FilterSection(
                      title: 'home.filters.sections.interestType.title'.tr(),
                      options: [
                        'home.filters.sections.interestType.options.flutter'
                            .tr(),
                        'home.filters.sections.interestType.options.uiUx'.tr(),
                        'home.filters.sections.interestType.options.advanced'
                            .tr(),
                        'home.filters.sections.interestType.options.beginnerFriendly'
                            .tr(),
                        'home.filters.sections.interestType.options.design'
                            .tr(),
                      ],
                      selectedOptions: _selectedFilters['Interest / Type']!,
                      onOptionSelected: (value) {
                        _toggleOption('Interest / Type', value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              decoration: BoxDecoration(
                color: AppColors.whiteBase,
                border: Border(top: BorderSide(color: AppColors.neutral200)),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _selectedCount == 0 ? null : _clearAll,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'home.filters.actions.clear'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _selectedCount == 0
                            ? AppColors.neutral400
                            : AppColors.primary500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Expanded(
                    child: SizedBox(
                      height: 42.h,
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.primary500,
                          foregroundColor: AppColors.whiteBase,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.all03,
                          ),
                        ),
                        child: Text(
                          _selectedCount == 0
                              ? 'home.filters.actions.apply'.tr()
                              : 'home.filters.actions.applyWithCount'.tr(
                                  args: [_selectedCount.toString()],
                                ),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteBase,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
