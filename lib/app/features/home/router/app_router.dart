import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/home_route/home_route_screen.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movements/movements_screen.dart';
import '../view/screen/login/login_screen.dart';
import '../view/screen/movement_form/movement_form_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String home = '/home_route';
  static const String movements = '/movements';
  static const String movementForm = '/movement_form';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeRouteScreen());
      case movements:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => MovementsScreen(
            partnerId: args['partnerId'],
            isSupplier: args['isSupplier'],
          ),
          settings: settings,
        );
      case movementForm:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => MovementFormScreen(
            partnerId: args['partnerId'],
            isSupplier: args['isSupplier'] ?? false,
            movementToEdit: args['movement'],
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Nenhuma rota definida para ${settings.name}'),
            ),
          ),
        );
    }
  }
}
