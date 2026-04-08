import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../../model/customer.dart';
import 'customer_viewmodel.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerViewModel>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            AppInput(
              onChanged: vm.setSearchQuery,
              label: "Procurar cliente",
              inputType: TextInputType.text,
              autoFocus: false,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: vm.customers.length,
                itemBuilder: (context, index) {
                  Customer customer = vm.customers[index];

                  return Dismissible(
                    key: Key(customer.id!),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await AppConfirmationDialog.show(
                        context: context,
                        title: "Confirmar",
                        content: "Deseja realmente excluir o cliente ${customer.name}?",
                        confirmText: "Excluir",
                      );
                    },
                    onDismissed: (direction) {
                      vm.deleteCustomer(customer.id!);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: customer.name,
                            style: TextStyle(
                              color: customer.canSale ? Colors.black : Colors.red,
                            ),
                          ),
                          AppText(
                            text: vm.currencyFormatter(customer.balance),
                            style: TextStyle(
                              color: customer.canSale ? Colors.black : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.pushNamed(context, AppRouter.movements, arguments: customer.id),
                      onLongPress: () => vm.openCustomerModal(context, vm, customer: customer),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => vm.openCustomerModal(context, vm),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
