import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/movements/movements_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
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
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),
          child: Column(
            spacing: 8,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: vm.movements.length,
                  itemBuilder: (context, index) {
                    Movement movement = vm.movements[index];

                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: vm.dateFormatter(movement.date.toDate(), false),
                            style: TextStyle(color: movement.isPayment ? Colors.green : Colors.black),
                          ),
                          AppText(
                            text: movement.isPayment ? "Pagamento" : "Venda",
                            style: TextStyle(color: movement.isPayment ? Colors.green : Colors.black),
                          ),
                          AppText(
                            text: vm.currencyFormatter(movement.amount),
                            style: TextStyle(color: movement.isPayment ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      onTap: () => vm.openNotesModal(context, movement.notes),
                      onLongPress: () => vm.openOptionsMenu(context),
                    );
                  },
                ),
              ),
              Divider(color: Colors.grey[300], thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: "Total"),
                  AppText(
                    text: vm.currencyFormatter(vm.customer != null ? vm.totalBalance : 0)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
