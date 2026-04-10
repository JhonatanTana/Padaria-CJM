import 'package:flutter/material.dart';
import 'app_text.dart';

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final Color iconColor;
  final IconData icon;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttonText = "OK",
    this.iconColor = Colors.orange,
    this.icon = Icons.warning_amber_rounded,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = "OK",
    bool isError = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AppAlertDialog(
        title: title,
        content: content,
        buttonText: buttonText,
        iconColor: isError ? const Color(0xFFD7263D) : Colors.orange,
        icon: isError ? Icons.error_outline : Icons.warning_amber_rounded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Icon(icon, color: iconColor, size: 48),
          const SizedBox(height: 16),
          AppText(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: AppText(
        text: content,
        style: const TextStyle(fontSize: 14),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: iconColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: AppText(
              text: buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
