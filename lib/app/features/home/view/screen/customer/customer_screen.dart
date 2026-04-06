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

  void _openCustomerModal(BuildContext context, CustomerViewModel vm, {Customer? customer}) {
    final TextEditingController nameController = TextEditingController(text: customer?.name ?? "");
    bool canSale = customer?.canSale ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: customer == null ? "Novo Cliente" : "Editar Cliente",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: nameController,
                label: "Nome",
                inputType: TextInputType.text,
                autoFocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pode vender?"),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: canSale,
                      activeTrackColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          canSale = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    if (nameController.text.isNotEmpty) {
                      if (customer == null) {
                        await vm.addCustomer(nameController.text, canSale);
                      } else {
                        customer.name = nameController.text;
                        customer.canSale = canSale;
                        await vm.updateCustomer(customer);
                      }
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const AppText(
                    text: "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

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
                      onLongPress: () => _openCustomerModal(context, vm, customer: customer),
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
        onPressed: () => _openCustomerModal(context, vm),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
