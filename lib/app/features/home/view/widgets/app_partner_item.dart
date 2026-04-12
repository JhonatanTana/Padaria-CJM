import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class AppPartnerItem extends StatelessWidget {
  final String name;
  final String balance;
  final bool canSale;
  final VoidCallback? onTap;

  const AppPartnerItem({
    super.key,
    required this.name,
    required this.balance,
    this.canSale = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = normalize(getAvatarColor(name));
    final bgColor = lighten(baseColor, 0.35);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: bgColor,
                child: Text(
                  getNameInitials(name),
                  style: TextStyle(
                    color: baseColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 20
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Arial'
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      balance,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontFamily: 'Arial'
                      ),
                    ),
                  ],
                ),
              ),

              /// Badge + Chevron
              Row(
                children: [
                  if (!canSale)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "NÃO VENDER",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Arial'
                        ),
                      ),
                    ),

                  const SizedBox(width: 8),

                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String getNameInitials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();
  }

  Color getAvatarColor(String name) {
    final hash = name.hashCode;
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = (hash & 0x0000FF);

    return Color.fromARGB(255, r, g, b);
  }

  Color lighten(Color color, [double amount = .85]) {
    final hsl = HSLColor.fromColor(color);
    final light = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return light.toColor();
  }

  Color normalize(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withSaturation(0.6).withLightness(0.5).toColor();
  }
}