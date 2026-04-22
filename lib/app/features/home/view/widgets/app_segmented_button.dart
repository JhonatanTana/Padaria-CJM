import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../model/segmented_button_options.dart';

class AppSegmentedButton<T> extends StatelessWidget {
  final T selected;
  final List<AppSegmentedButtonOption<T>> options;
  final ValueChanged<T> onSelectionChanged;

  const AppSegmentedButton({
    super.key,
    required this.selected,
    required this.options,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = selected == option.value;
          return GestureDetector(
            onTap: () => onSelectionChanged(option.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Text(
                option.label,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Arial',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}