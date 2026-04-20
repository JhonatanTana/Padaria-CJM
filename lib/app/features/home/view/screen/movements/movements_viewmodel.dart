import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/router/app_router.dart';
import 'package:padaria_cjm2/app/features/home/services/customer_service.dart';
import 'package:padaria_cjm2/app/features/home/services/supplier_service.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_alert_dialog.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_confirmation_dialog.dart';

import '../../../../../../main.dart';
import '../../../model/customer.dart';
import '../../../model/supplier.dart';
import '../../../services/movements_service.dart';

class MovementsViewModel extends ChangeNotifier {
  final _customerService = CustomerService();
  final _supplierService = SupplierService();
  final _service = MovementsService();

  String? partnerId;
  bool isSupplier;
  Customer? customer;
  Supplier? supplier;
  StreamSubscription<List<Movement>>? _subscription;
  List<Movement> movements = [];

  MovementsViewModel({this.partnerId, required this.isSupplier}) {

    if(!isSupplier) {
      _getCustomerById();
    } else {
      _getSupplierById();
    }
    _getMovements();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _getCustomerById() async {
    if (partnerId == null) return;
    try {
      customer = await _customerService.getCustomerById(partnerId!);

      if(customer?.canSale == false) {
        AppAlertDialog.show(
          context: navigatorKey.currentContext!,
          title: 'Atenção',
          content: 'Não vender a esse cliente'
        );
      }

      notifyListeners();
    } on Exception catch (e) {
      AppAlertDialog.show(
        context: navigatorKey.currentContext!,
        title: "Erro",
        content: e.toString(),
        isError: true,
      );
    }
  }

  void _getSupplierById() async {
    if (partnerId == null) return;
    try {
      supplier = await _supplierService.getSupplierById(partnerId!);
      notifyListeners();
    } on Exception catch (e) {
      AppAlertDialog.show(
        context: navigatorKey.currentContext!,
        title: "Erro",
        content: e.toString(),
        isError: true,
      );
    }
  }

  void _getMovements() {
    if (partnerId == null) return;

    _subscription?.cancel();
    _subscription = _service.getMovementsByPartnerId(partnerId!, isSupplier).listen((newList) {
      movements = newList;

      movements.sort((a, b) =>
          b.date.compareTo(a.date));

      notifyListeners();
    }, onError: (e) {
      AppAlertDialog.show(
        context: navigatorKey.currentContext!,
        title: "Erro",
        content: "Erro ao carregar movimentos",
        isError: true,
      );    
    });
  }

  String currencyFormatter(double amount) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(amount);
  }

  double get totalBalance {
    double total = 0.0;

    for (var movement in movements) {
      total += movement.amount;
    }

    return total;
  }

  void openNotesModal(BuildContext context, String? notes) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) =>
        StatefulBuilder(builder: (context, setState) =>
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 64,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [

                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Observações:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Text(
                    notes ?? "",
                    style: const TextStyle(
                      fontSize: 14
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      isScrollControlled: true
    );
  }

  void openOptionsMenu(BuildContext context, Movement movement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16,
          left: 8,
          right: 8,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [

                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);

                        Navigator.pushNamed(context, AppRouter.movementForm, arguments: {
                          'partnerId': partnerId,
                          'isSupplier': isSupplier,
                          'movement': movement,
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.edit,
                              color: Colors.grey.shade800,
                              size: 28,
                            ),
                            Text(
                              "Editar",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: InkWell(
                      onTap: () => _deleteMovement(movement),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.grey.shade800,
                              size: 28,
                            ),
                            Text(
                              "Deletar",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMovement(Movement movement) async {
    if (partnerId == null || movement.id == null) return;

    final confirmed = await AppConfirmationDialog.show(
      context: navigatorKey.currentContext!,
      title: 'Exclusão',
      content: 'Deseja excluir a movimentação selecionada?',
      cancelText: 'Cancelar',
      confirmText: 'Excluir',
    );

    if (confirmed != true) return;

    try {
      Navigator.pop(navigatorKey.currentContext!);

      await _service.deleteMovement(partnerId!, isSupplier, movement.id!);
      await _updatePartnerBalance(movement.amount * -1);

    } catch (e) {
      AppAlertDialog.show(
        context: navigatorKey.currentContext!,
        title: "Erro",
        content: e.toString(),
        isError: true,
      );
    }
  }

  Future<void> _updatePartnerBalance(double amountChange) async {
    if (isSupplier) {
      if (supplier == null) return;
      try {
        supplier!.balance += amountChange;
        await _supplierService.updateBalance(supplier!.id!, supplier!.balance);
        notifyListeners();
      } catch (e) {
        _showError(e.toString());
      }
    } else {
      if (customer == null) return;
      try {
        customer!.balance += amountChange;
        await _customerService.updateBalance(customer!.id!, customer!.balance);
        notifyListeners();
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  void _showError(String message) {
    AppAlertDialog.show(
      context: navigatorKey.currentContext!,
      title: "Erro",
      content: message,
      isError: true,
    );
  }
}