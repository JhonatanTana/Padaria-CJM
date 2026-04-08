import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/bottom_navigation.dart';

class AppBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<BottomNavigation> items;

  const AppBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final isSelected = index == selectedIndex;
            final item = items[index];

            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0x1AD7263D): Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      (item.icon).icon,
                      color: isSelected ? const Color(0xFFD7263D) : Colors.grey,
                    ),
                    if (isSelected) ...[
                      Text(
                        item.title,
                        style: const TextStyle(
                            color: Color(0xFFD7263D),
                            fontWeight: FontWeight.w600,
                            fontSize: 10
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
    /*return BottomNavigationBar(
      items: [
        for (var item in items)
          BottomNavigationBarItem(
            icon: item.icon,
            label: item.title,
          ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: const Color(0xFFD7263D),
      onTap: onItemTapped,
    );
  }*/
}
