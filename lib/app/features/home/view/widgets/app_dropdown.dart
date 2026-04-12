import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String label;
  final Function(T?) onChanged;
  final String Function(T) itemLabel;

  const AppDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemLabel,
    this.label = "",
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return DropdownButtonFormField<T>(
      initialValue: widget.value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      dropdownColor: const Color(0xFFF8F9FB),
      focusColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Colors.grey,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            widget.itemLabel(item),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
