import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        AppShimmer(
          width: double.infinity,
          height: 48,
          borderRadius: BorderRadius.circular(32),
        ),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: AppShimmer(
                width: double.infinity,
                height: 100,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            Expanded(
              child: AppShimmer(
                width: double.infinity,
                height: 100,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
