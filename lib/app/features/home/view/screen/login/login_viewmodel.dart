import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/services/auth_service.dart';

import '../home_route/home_route_screen.dart';

class LoginViewModel extends ChangeNotifier {
  final _service = AuthService();
  final _storage = const FlutterSecureStorage();

  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  LoginViewModel() {
    _init();
  }

  Future<void> _init() async {
    email.text = await _storage.read(key: "email") ?? '';
    password.text = await _storage.read(key: "password") ?? '';
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    String? response = await _service.login(email.text, password.text);

    if (response == null) {
      isLoading = false;
      notifyListeners();

      _storage.write(key: "email", value: email.text);
      _storage.write(key: "password", value: password.text);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRouter.home);
      }
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}