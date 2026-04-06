import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
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
              AppInput(
                controller: vm.email,
                label: "Email",
                inputType: TextInputType.emailAddress,
              ),

              AppInput(
                controller: vm.password,
                label: "Senha",
                obscureText: true,
                inputType: TextInputType.visiblePassword,
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
