import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/home_route/home_route_screen.dart';
import '../view/screen/login/login_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home_route';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeRouteScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Nenhuma rota definida para ${settings.name}')),
          ),
        );
    }
  }
}