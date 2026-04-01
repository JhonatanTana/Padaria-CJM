import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_topbar.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_bottombar.dart';
import 'home_route_viewmodel.dart';

class HomeRouteScreen extends StatelessWidget {
  const HomeRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeRouteViewModel(),
      child: Consumer<HomeRouteViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppTopBar(
              title: vm.items[vm.selectedIndex].title,
              actions: [
                IconButton(
                  icon: vm.items[vm.selectedIndex].actionIcon,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  },
                ),
              ],
            ),
            body: vm.widgetOptions.elementAt(vm.selectedIndex),
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
