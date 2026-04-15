import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_partner_item.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_partner_shimmer.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_confirmation_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/currency_formatter.dart';
import '../../../model/customer.dart';
import '../../widgets/app_search.dart';
import 'customer_viewmodel.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [

            AppSearch(
              title: "Pesquisar cliente",
              onChanged: vm.setSearchQuery,
            ),

            Expanded(
              child: vm.isLoading ?
              ListView.builder(itemCount: 6, itemBuilder: (context, index) => const AppPartnerShimmer()) :
              ListView.builder(
                itemCount: vm.customers.length,
                itemBuilder: (context, index) {
                  Customer customer = vm.customers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Dismissible(
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
                      onDismissed: (direction) =>
                          vm.deleteCustomer(customer.id!),
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerRight,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        child:
                        const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.movements,
                          arguments: customer.id,
                        ),
                        onLongPress: () =>
                            vm.openCustomerModal(context, vm,
                                customer: customer),
                        child: AppPartnerItem(
                          name: customer.name,
                          balance: CurrencyFormatter.format(customer.balance),
                          canSale: customer.canSale,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        onPressed: () => vm.openCustomerModal(context, vm),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
