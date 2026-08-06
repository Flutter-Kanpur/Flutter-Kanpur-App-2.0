import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_borders.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_removable_chip.dart';

/// Labelled dropdown that accumulates selections as removable chips beneath it.
///
/// Used for Tech stack, Category and Tags. Picking an option adds a chip;
/// tapping the chip's ✕ removes it. Options already chosen are hidden from the
/// menu, so the same value cannot be added twice.
///
/// Set [maxSelections] to 1 for single-select fields (Category) — the dropdown
/// then replaces the current selection instead of appending.
class FkMultiSelectField extends StatelessWidget {
  const FkMultiSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.hint = '-select-',
    this.maxSelections,
    this.errorText,
    this.emptyMenuLabel = 'Nothing left to choose',
  });

  final String label;
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final String hint;

  /// Null means unlimited. 1 makes the field behave as single-select.
  final int? maxSelections;

  /// Rendered under the chips; drive it from your form validation.
  final String? errorText;
  final String emptyMenuLabel;

  bool get _isSingleSelect => maxSelections == 1;
  bool get _isFull =>
      maxSelections != null && selected.length >= maxSelections!;

  void _add(String value) {
    if (_isSingleSelect) {
      onChanged([value]);
      return;
    }
    if (selected.contains(value) || _isFull) return;
    onChanged([...selected, value]);
  }

  void _remove(String value) {
    onChanged(selected.where((v) => v != value).toList());
  }

  @override
  Widget build(BuildContext context) {
    // Single-select keeps the current value visible in the menu; multi-select
    // hides what's already chosen.
    final available = _isSingleSelect
        ? options
        : options.where((o) => !selected.contains(o)).toList();

    final hasError = errorText != null && errorText!.isNotEmpty;
    // Adding is blocked when the cap is reached or nothing is left to pick.
    final canAdd = available.isNotEmpty && (!_isFull || _isSingleSelect);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: AppSpacing.v10),
        ],
        Container(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.h16),
          decoration: BoxDecoration(
            color: AppColors.whiteBase,
            borderRadius: AppRadius.all03,
            border: Border.all(
              color: hasError ? AppColors.warning600 : AppBorders.primary,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: null,
              isExpanded: true,
              borderRadius: AppRadius.all03,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              padding: EdgeInsets.symmetric(vertical: AppSpacing.v6),
              hint: Text(
                _isSingleSelect && selected.isNotEmpty ? selected.first : hint,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: _isSingleSelect && selected.isNotEmpty
                      ? AppColors.neutral950
                      : AppColors.neutral300,
                ),
              ),
              items: canAdd
                  ? available
                        .map(
                          (o) => DropdownMenuItem<String>(
                            value: o,
                            child: Text(o),
                          ),
                        )
                        .toList()
                  : const [],
              // A null onChanged greys the control out, which is the right
              // affordance once the cap is hit or the list is exhausted.
              onChanged: canAdd
                  ? (value) {
                      if (value != null) _add(value);
                    }
                  : null,
              disabledHint: Text(
                _isFull ? 'Maximum $maxSelections selected' : emptyMenuLabel,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.neutral400),
              ),
            ),
          ),
        ),
        if (selected.isNotEmpty) ...[
          SizedBox(height: AppSpacing.v12),
          Wrap(
            spacing: AppSpacing.h8,
            runSpacing: AppSpacing.v8,
            children: selected
                .map(
                  (value) => FkRemovableChip(
                    label: value,
                    onRemove: () => _remove(value),
                  ),
                )
                .toList(),
          ),
        ],
        if (hasError) ...[
          SizedBox(height: AppSpacing.v6),
          Text(
            errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.warning600),
          ),
        ],
      ],
    );
  }
}
