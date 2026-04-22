import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_partner_item.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_partner_shimmer.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_confirmation_dialog.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/currency_formatter.dart';
import '../../../model/customer.dart';
import '../../widgets/app_search.dart';
import 'customer_cubit.dart';
import 'customer_state.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerCubit()..loadCustomers(),
      child: const CustomerView(),
    );
  }
}

class CustomerView extends StatelessWidget {
  const CustomerView({super.key});

  void _openCustomerModal(BuildContext context, CustomerCubit cubit, {Customer? customer}) {
    final TextEditingController nameController = TextEditingController(text: customer?.name ?? "");
    bool canSale = customer?.canSale ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      customer == null ? "Novo Cliente" : "Editar Cliente",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Arial"
                      ),
                    ),
                  ),

                  AppInput(
                    controller: nameController,
                    label: "Nome",
                    keyboardType: TextInputType.text,
                    autofocus: true,
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pode vender?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontFamily: "Arial"
                          ),
                        ),
                        Switch.adaptive(
                          value: canSale,
                          activeTrackColor: const Color(0xFFD7263D).withValues(alpha: .8),
                          thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.selected)) return Colors.white;
                            return Colors.grey;
                          }),
                          onChanged: (value) => setState(() => canSale = value),
                        )
                      ],
                    ),
                  ),

                  AppButton(
                    text: "Salvar",
                    onPressed: () async {
                      if (nameController.text.isNotEmpty) {
                        if (customer == null) {
                          await cubit.addCustomer(nameController.text, canSale);
                        } else {
                          customer.name = nameController.text;
                          customer.canSale = canSale;
                          await cubit.updateCustomer(customer);
                        }
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                    isLoading: false,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomerCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          spacing: 8,
          children: [

            AppSearch(
              title: "Pesquisar cliente",
              onChanged: cubit.setSearchQuery,
            ),

            Expanded(
              child: BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  if (state is CustomerLoading || state is CustomerInitial) {
                    return ListView.builder(itemCount: 6, itemBuilder: (context, index) => const AppPartnerShimmer());
                  }

                  if (state is CustomerError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is CustomerLoaded) {
                    return ListView.builder(
                      itemCount: state.customers.length,
                      itemBuilder: (context, index) {
                        Customer customer = state.customers[index];

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
                                cubit.deleteCustomer(customer.id!),
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
                                if (customer.id != null) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRouter.movements,
                                    arguments: {
                                      'partnerId': customer.id!,
                                      'isSupplier': false,
                                    },
                                  );
                                }
                              },
                              onLongPress: () =>
                                  _openCustomerModal(context, cubit, customer: customer),
                              child: AppPartnerItem(
                                name: customer.name,
                                balance: CurrencyFormatter.format(customer.balance),
                                canSale: customer.canSale,
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
        onPressed: () => _openCustomerModal(context, cubit),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
