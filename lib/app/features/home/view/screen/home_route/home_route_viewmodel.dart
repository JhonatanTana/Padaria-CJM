import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/bottom_navigation.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/supplier/supplier_screen.dart';

import '../../../router/app_router.dart';
import '../customer/customer_screen.dart';
import '../home/home_screen.dart';

class HomeRouteViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<Widget> get widgetOptions => _widgetOptions;

  final List<Widget> _widgetOptions = const <Widget>[
    HomeScreen(),
    CustomerScreen(),
    SupplierScreen(),
  ];

  List<BottomNavigation> items = [
    BottomNavigation(
      title: "Início",
      icon: Icon(Icons.home),
      actionIcon: Icon(Icons.logout),
      action: AppRouter.login
    ),
    BottomNavigation(
      title: "Clientes",
      icon: Icon(Icons.person),
      actionIcon: Icon(Icons.add),
      action: AppRouter.home
    ),
    BottomNavigation(
      title: "Fornecedores",
      icon: Icon(Icons.groups),
      actionIcon: Icon(Icons.add),
      action: AppRouter.home
    ),
  ];

  void onItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
