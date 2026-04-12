import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),

              AppInput(
                controller: vm.email,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: AppInput.combine([
                  AppInput.required(),
                  AppInput.email(),
                ]),
              ),

              AppInput(
                controller: vm.password,
                label: "Senha",
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                prefixIcon: Icons.lock,
                validator: AppInput.combine([
                  AppInput.required(),
                  AppInput.password(),
                ]),
              ),

              AppButton(
                isLoading: vm.isLoading,
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
