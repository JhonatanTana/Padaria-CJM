import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AppRadio<T> extends StatelessWidget {
  final List<T> values;
  final List<String> labels;
  final T? value;
  final Function(T?) onChanged;

  const AppRadio({
    super.key,
    required this.values,
    required this.labels,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: value,
      onChanged: onChanged,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < values.length; i++)
            GestureDetector(
              onTap: () => onChanged(values[i]),
              child: Row(
                children: [
                  Radio<T>(
                    value: values[i],
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primary;
                      }
                      return Colors.grey;
                    }),
                  ),
                  Text(labels[i]),
                ],
              ),
            ),
        ],
      ),
    );
  }
}