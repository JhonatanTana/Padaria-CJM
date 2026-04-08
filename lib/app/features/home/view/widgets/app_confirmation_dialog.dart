import 'package:flutter/material.dart';
import 'app_text.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final Color confirmColor;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = "Cancelar",
    this.confirmText = "Confirmar",
    this.confirmColor = const Color(0xFFD7263D),
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String cancelText = "Cancelar",
    String confirmText = "Confirmar",
    Color confirmColor = const Color(0xFFD7263D),
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: title,
        content: content,
        cancelText: cancelText,
        confirmText: confirmText,
        confirmColor: confirmColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: AppText(
        text: title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: AppText(text: content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: AppText(
            text: cancelText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: AppText(
            text: confirmText,
            style: TextStyle(color: confirmColor),
          ),
        ),
      ],
    );
  }
}
