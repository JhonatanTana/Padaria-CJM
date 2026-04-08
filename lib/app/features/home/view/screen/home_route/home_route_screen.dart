import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/bottom_navigation.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_top_bar.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_bottom_bar.dart';
import 'home_route_viewmodel.dart';

class HomeRouteScreen extends StatelessWidget {
  const HomeRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeRouteViewModel(),
      child: Consumer<HomeRouteViewModel>(
        builder: (context, vm, child) {
          BottomNavigation item = vm.items[vm.selectedIndex];

          return Scaffold(
            backgroundColor: Color(0xFFF8F9FB),
            appBar: AppTopBar(
              title: item.title,
              actions: [
                if (item.action != null)
                  IconButton(
                    icon: item.actionIcon,
                    onPressed: () {
                      Navigator.pushNamed(context, item.action!);
                    },
                  ),
              ],
            ),
            body: PageView(
              controller: vm.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: vm.widgetOptions,

            ),
            bottomNavigationBar: AppBottomBar(
              selectedIndex: vm.selectedIndex,
              onItemTapped: vm.onItemTapped,
              items: vm.items,
            ),
          );
        },
      ),
    );
  }
}
