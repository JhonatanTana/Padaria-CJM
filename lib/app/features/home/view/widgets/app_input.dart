/*
import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/core/constants/app_colors.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';

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
  final IconData? prefixIcon;
  final double? height;
  final bool showLabel;

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
    this.height = 1,
    this.prefixIcon,
    this.showLabel = false,
  });

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  final FocusNode _focusNode = FocusNode();
  late bool _obscureText;

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Visibility(
          visible: widget.showLabel,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppText(
              text: widget.label,
            ),
          ),
        ),

        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: _focusNode.hasFocus ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ] : [],
          ),
          child: TextField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.inputType,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              hintText: widget.label,
              hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1.2,
                ),
              ),
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, size: 20) : null,
              suffixIcon: widget.suffixIcon ?? (widget.obscureText ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey.shade700,
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ) : null),
            ),
            autofocus: widget.autoFocus,
            style: TextStyle(
              height: 1.2,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
*/

import 'package:flutter/material.dart';

typedef Validator = String? Function(String?);

class AppInput extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool autofocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final Validator? validator;
  final bool showLabel;

  const AppInput({
    super.key,
    required this.label,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.showLabel = false,
  });

  static Validator required({String message = 'Campo obrigatório'}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return message;
      }
      return null;
    };
  }

  static Validator email({String message = 'Email inválido'}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!regex.hasMatch(value)) return message;
      return null;
    };
  }

  static Validator password({
    int minLength = 6,
    String message = 'Senha muito curta',
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < minLength) return message;
      return null;
    };
  }

  static Validator minLength(int length, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < length) {
        return message ?? 'Mínimo de $length caracteres';
      }
      return null;
    };
  }

  static Validator combine(List<Validator> validators) {
    return (value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late bool _obscureText;
  String? _error;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _validate(String? value) {
    if (widget.validator != null) {
      setState(() {
        _error = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [

        Visibility(
          visible: widget.showLabel,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Arial"
              ),
            ),
          )
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            autofocus: widget.autofocus,
            onChanged: (value) {
              widget.onChanged?.call(value);
              _validate(value);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            cursorColor: Colors.red,

            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: TextStyle(
                fontFamily: 'Arial'
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              prefixIcon: widget.prefixIcon != null ? Icon(
                widget.prefixIcon,
                color: Colors.grey.shade800,
              ) : null,
              suffixIcon: _buildSuffix(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                  width: 1.5,
                ),
              ),
              errorText: _error,
              errorStyle: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffixIcon != null) return widget.suffixIcon;

    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
        color: Colors.grey.shade800,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return null;
  }
}