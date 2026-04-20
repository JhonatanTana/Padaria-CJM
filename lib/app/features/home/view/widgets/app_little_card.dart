import 'package:flutter/material.dart';

class AppLittleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundIconColor;


  const AppLittleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 4,
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
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
