import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movements/movements_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_top_bar.dart';
import 'package:provider/provider.dart';

class MovementsScreen extends StatelessWidget {
    const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementsViewModel>();

    return Scaffold(
      appBar: AppTopBar(
          title: vm.customer?.name ?? "Movimentações",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            spacing: 8,
            children: [
              const Expanded(
                  child: Placeholder()
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    ),
                  ),
                  Text(
                    vm.currencyFormatter(vm.customer != null ? vm.customer!.balance : 0),
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                        fontSize: 16
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )

    );
  }
}
