import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/core/constants/currency_formatter.dart';
import 'package:padaria_cjm2/app/features/home/model/supplier.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_search.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../router/app_router.dart';
import '../../widgets/app_confirmation_dialog.dart';
import '../../widgets/app_partner_item.dart';
import '../../widgets/app_partner_shimmer.dart';
import 'supplier_cubit.dart';
import 'supplier_state.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupplierCubit()..loadSuppliers(),
      child: const SupplierView(),
    );
  }
}

class SupplierView extends StatelessWidget {
  const SupplierView({super.key});

  void _openSupplierModal(BuildContext context, SupplierCubit cubit, Supplier? supplier) {
    final TextEditingController nameController = TextEditingController(text: supplier?.name ?? "");

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 16,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [

              AppText(
                text: supplier != null ? "Editar Fornecedor" : "Novo Fornecedor",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Arial"
                ),
              ),

              AppInput(
                label: "Nome",
                controller: nameController,
              ),

              AppButton(
                text: "Salvar",
                onPressed: () {
                   if (supplier != null) {
                     supplier.name = nameController.text;
                     cubit.updateSupplier(supplier);
                   } else {
                     cubit.addSupplier(nameController.text);
                   }
                   Navigator.pop(modalContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupplierCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [
            AppSearch(
              title: "Pesquisar fornecedor",
              onChanged: cubit.setSearchQuery,
            ),

            Expanded(
              child: BlocBuilder<SupplierCubit, SupplierState>(
                builder: (context, state) {
                  if (state is SupplierLoading || state is SupplierInitial) {
                    return ListView.builder(itemCount: 6, itemBuilder: (context, index) => const AppPartnerShimmer());
                  }

                  if (state is SupplierError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is SupplierLoaded) {
                    return ListView.builder(
                      itemCount: state.suppliers.length,
                      itemBuilder: (context, index) {
                        Supplier supplier = state.suppliers[index];

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
                              cubit.deleteSupplier(supplier.id!);
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
                              onTap: () {
                                if (supplier.id != null) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.movements,
                                    arguments: {
                                      'partnerId': supplier.id!,
                                      'isSupplier': true,
                                    },
                                  );
                                }
                              },
                              onLongPress: () =>
                                  _openSupplierModal(context, cubit, supplier),
                              child: AppPartnerItem(
                                name: supplier.name,
                                balance: CurrencyFormatter.format(supplier.balance),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
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
        onPressed: () => _openSupplierModal(context, cubit, null),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
