import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movements/movements_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_movement_item.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_top_bar.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovementsViewModel>();

    return Scaffold(
      appBar: AppTopBar(
        title: vm.isSupplier ? (vm.supplier?.name ?? "Movimentações") : (vm.customer?.name ?? "Movimentações")
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: vm.movements.length,
                  itemBuilder: (context,index) {
                    Movement movement = vm.movements[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                      child: AppMovementItem(
                        item: movement,
                        onTap: () => vm.openNotesModal(context,movement.notes),
                        onLongPress: () => vm.openOptionsMenu(context,movement)
                      )
                    );
                  },
                ),
              ),

              Divider(color: Colors.grey[300], thickness: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText(text: "Total"),
                  AppText(
                    text: vm.currencyFormatter(vm.totalBalance)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 48),
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          onPressed: () => Navigator.pushNamed(
            context, 
            AppRouter.movementForm, 
            arguments: {
              'partnerId': vm.partnerId,
              'isSupplier': vm.isSupplier,
            }
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
