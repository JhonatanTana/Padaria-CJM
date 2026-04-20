import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AppDropdown<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedValue = ValueNotifier<T?>(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          isExpanded: true,
          hint: Text(label),

          valueListenable: selectedValue,

          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
            height: 50,
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 220,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
          ),

          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
          ),

          items: items.map((item) {
            return DropdownItem<T>(
              value: item,
              child: Text(
                itemLabel(item),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),

          onChanged: (newValue) {
            selectedValue.value = newValue;
            onChanged(newValue);
          },
        ),
      ),
    );
  }
}
