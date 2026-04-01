import 'package:flutter/material.dart';
import '../view/screen/home/home_screen.dart';
import '../view/screen/login/login_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Nenhuma rota definida para ${settings.name}')),
          ),
        );
    }
  }
}