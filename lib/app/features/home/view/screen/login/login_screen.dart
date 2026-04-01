import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_button.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: vm.email,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: vm.password,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Senha"),
                  border: OutlineInputBorder(),
                ),
              ),
              AppButton(
                text: vm.isLoading ? "Carregando..." : "Entrar",
                onPressed: () => vm.login(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
