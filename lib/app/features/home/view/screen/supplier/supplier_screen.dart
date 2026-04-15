import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/core/constants/currency_formatter.dart';
import 'package:padaria_cjm2/app/features/home/model/supplier.dart';
import 'package:padaria_cjm2/app/features/home/view/screen/supplier/supplier_viewmodel.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_search.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../router/app_router.dart';
import '../../widgets/app_confirmation_dialog.dart';
import '../../widgets/app_partner_item.dart';
import '../../widgets/app_partner_shimmer.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SupplierViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            AppSearch(
              title: "Pesquisar fornecedor",
              onChanged: vm.setSearchQuery,
            ),

            Expanded(
              child: vm.isLoading ?
              ListView.builder(itemCount: 6, itemBuilder: (context, index) => const AppPartnerShimmer()) :
              ListView.builder(
                itemCount: vm.suppliers.length,
                itemBuilder: (context, index) {
                  Supplier supplier = vm.suppliers[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Dismissible(
                      key: Key(supplier.id!),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await AppConfirmationDialog.show(
                          context: context,
                          title: "Confirmar",
                          content: "Deseja realmente excluir o Fornecedor ${supplier.name}?",
                          confirmText: "Excluir",
                        );
                      },
                      onDismissed: (direction) {
                        vm.deleteSupplier(context, supplier.id!);
                      },
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
                          arguments: supplier.id,
                        ),
                        onLongPress: () =>
                            vm.openSupplierModal(context, supplier),
                        child: AppPartnerItem(
                          name: supplier.name,
                          balance: CurrencyFormatter.format(supplier.balance),
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
        onPressed: () => vm.openSupplierModal(context, null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
