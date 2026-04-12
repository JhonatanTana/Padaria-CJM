import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: widget.value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: Colors.grey,
      ),
      dropdownColor: Colors.white,
      elevation: 2,

      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: const TextStyle(fontFamily: 'Arial'),

        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
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
