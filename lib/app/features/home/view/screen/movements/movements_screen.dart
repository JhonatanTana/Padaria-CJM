import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:padaria_cjm2/app/core/constants/currency_formatter.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_movement_item.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_top_bar.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_confirmation_dialog.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_alert_dialog.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_movement_shimmer.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import 'movements_cubit.dart';
import 'movements_state.dart';

class MovementsScreen extends StatelessWidget {
  final String partnerId;
  final bool isSupplier;

  const MovementsScreen({
    super.key,
    required this.partnerId,
    required this.isSupplier,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovementsCubit(partnerId: partnerId, isSupplier: isSupplier)..loadData(),
      child: const MovementsView(),
    );
  }
}

class MovementsView extends StatelessWidget {
  const MovementsView({super.key});

  void _openNotesModal(BuildContext context, String? notes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Observações",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AppText(text: notes ?? "Sem observações"),
          ],
        ),
      ),
    );
  }

  void _openOptionsMenu(BuildContext context, Movement movement, MovementsCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Editar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRouter.movementForm,
                  arguments: {
                    'partnerId': cubit.partnerId,
                    'isSupplier': cubit.isSupplier,
                    'movement': movement,
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Excluir"),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await AppConfirmationDialog.show(
                  context: context,
                  title: "Confirmar",
                  content: "Deseja realmente excluir esta movimentação?",
                );
                if (confirm == true) {
                  cubit.deleteMovement(movement);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MovementsCubit>();

    return BlocBuilder<MovementsCubit, MovementsState>(
      builder: (context, state) {
        String title = "Movimentações";
        if (state is MovementsLoaded) {
          title = state.isSupplier ? (state.supplier?.name ?? "Movimentações") : (state.customer?.name ?? "Movimentações");
        }

        return Scaffold(
          appBar: AppTopBar(title: title),
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is MovementsLoading || state is MovementsInitial) {
                          return ListView.builder(
                            itemCount: 8,
                            itemBuilder: (context, index) => const AppMovementShimmer(),
                          );
                        }

                        if (state is MovementsError) {
                          return Center(child: Text(state.message));
                        }

                        if (state is MovementsLoaded) {
                          return ListView.builder(
                            itemCount: state.movements.length,
                            itemBuilder: (context, index) {
                              Movement movement = state.movements[index];
                              return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                  child: AppMovementItem(
                                    item: movement,
                                    onTap: () => _openNotesModal(context, movement.notes),
                                    onLongPress: () => _openOptionsMenu(context, movement, cubit),
                                    isSupplier: state.isSupplier,
                                  )
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  if (state is MovementsLoaded) ...[
                    Divider(color: Colors.grey[300], thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(text: "Total"),
                        AppText(
                            text: CurrencyFormatter.format(state.totalBalance)
                        ),
                      ],
                    ),
                  ]
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
                    'partnerId': cubit.partnerId,
                    'isSupplier': cubit.isSupplier,
                  }
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
