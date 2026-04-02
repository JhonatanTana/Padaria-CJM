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
    return BottomNavigationBar(
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
  }
}
