import 'package:flutter/material.dart';

import '../../../../core/constants/currency_formatter.dart';

class AppLittleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundIconColor;
  final double amount;

  const AppLittleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundIconColor,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: backgroundIconColor,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 18,
                  )
                ),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Arial'
                  ),
                ),
              ],
            ),

            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 1),
              tween: Tween<double>(begin: 0, end: amount),
              builder: (context, value, child) {
                return Text(
                  CurrencyFormatter.format(value),
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
