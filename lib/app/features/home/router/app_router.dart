import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/home_route/home_route_screen.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movement_form/movement_form_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movements/movements_screen.dart';
import 'package:provider/provider.dart';
import '../view/screen/login/login_screen.dart';
import '../view/screen/movement_form/movement_form_screen.dart';
import '../view/screen/movements/movements_viewmodel.dart';

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
        final partnerId = args['partnerId'] as String;
        final isSupplier = args['isSupplier'] as bool;

        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MovementsViewModel(partnerId: partnerId, isSupplier: isSupplier),
            child: const MovementsScreen(),
          ),
        );
      case movementForm:
        final args = settings.arguments as Map<String, dynamic>;
        final partnerId = args['partnerId'] as String;
        final isSupplier = args['isSupplier'] as bool? ?? false;
        final movement = args['movement'] as Movement?;
        
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => MovementFormViewModel(
              partnerId: partnerId,
              isSupplier: isSupplier,
              movementToEdit: movement,
            ),
            child: const MovementFormScreen(),
          ),
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
