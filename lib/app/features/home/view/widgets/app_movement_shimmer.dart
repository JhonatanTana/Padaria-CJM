import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

class AppMovementShimmer extends StatelessWidget {
  const AppMovementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            AppShimmer.circular(size: 44),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(width: 100, height: 16),
                  SizedBox(height: 8),
                  AppShimmer(width: 60, height: 14),
                ],
              ),
            ),
            SizedBox(width: 8),
            AppShimmer(width: 60, height: 16),
          ],
        ),
      ),
    );
  }
}
