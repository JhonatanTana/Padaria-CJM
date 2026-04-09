import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/bottom_navigation.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/product/product_screen.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/supplier/supplier_screen.dart';

import '../../../router/app_router.dart';
import '../customer/customer_screen.dart';
import '../home/home_screen.dart';

class HomeRouteViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  List<Widget> get widgetOptions => _widgetOptions;
  final PageController pageController = PageController();

  final List<Widget> _widgetOptions = const <Widget>[
    HomeScreen(key: ValueKey(0)),
    CustomerScreen(key: ValueKey(1)),
    SupplierScreen(key: ValueKey(2)),
    ProductScreen(key: ValueKey(3)),
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
      action: null
    ),
    BottomNavigation(
      title: "Fornecedores",
      icon: Icon(Icons.person_4),
      actionIcon: Icon(Icons.add),
      action: null
    ),
    BottomNavigation(
      title: "Produtos",
      icon: Icon(Icons.inventory_2),
      actionIcon: Icon(Icons.add),
      action: null
    ),
  ];

  void onItemTapped(int index) {
    _selectedIndex = index;
    pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
    );
    notifyListeners();
  }
}
