import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

class AppPartnerShimmer extends StatelessWidget {
  const AppPartnerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const AppShimmer.circular(size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 16,
                  ),
                  const SizedBox(height: 8),
                  AppShimmer(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 14,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const AppShimmer(width: 24, height: 24, borderRadius: BorderRadius.all(Radius.circular(4))),
          ],
        ),
      ),
    );
  }
}
