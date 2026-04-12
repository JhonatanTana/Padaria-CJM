import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/core/constants/app_colors.dart';

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputType? inputType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool autoFocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final double? height;

  const AppInput({
    super.key,
    required this.label,
    this.controller,
    this.inputType,
    this.obscureText = false,
    this.onChanged,
    this.autoFocus = false,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.height = 1
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

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

    return TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.inputType,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(
          color: isFocused ?  AppColors.primary : Colors.grey,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: widget.suffixIcon ?? (widget.obscureText ? IconButton(
          icon: Icon( _obscureText ? Icons.visibility : Icons.visibility_off ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : null),
      ),
      autofocus: widget.autoFocus,
      style: TextStyle(
        height: widget.height,
      ),
    );
  }
}
