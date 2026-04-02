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
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Email"),
                  border: OutlineInputBorder(),
                ),
              ),
              TextFormField(
                controller: vm.password,
                obscureText: vm.obscureText,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  label: Text("Senha"),
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => vm.toggleView(),
                  ),
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
