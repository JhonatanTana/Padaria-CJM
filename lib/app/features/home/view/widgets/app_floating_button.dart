import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AppFloatingButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      onPressed: () => onPressed,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
