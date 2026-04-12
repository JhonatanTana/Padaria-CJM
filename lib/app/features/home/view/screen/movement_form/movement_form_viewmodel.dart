import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:padaria_cjm2/app/features/home/model/customer.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/services/movements_service.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_alert_dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:padaria_cjm2/main.dart';

import '../../../services/customer_service.dart';

class MovementFormViewModel extends ChangeNotifier {
  final _service = MovementsService();
  final _customerService = CustomerService();

  final String customerId;
  final Movement? movementToEdit;

  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  bool _isSale = false;
  String? paymentMethod = "";

  late Timestamp selectedTimestamp;
  double _oldAmount = 0;

  bool get isSale => _isSale;

  set isSale(bool value) {
    _isSale = value;
    notifyListeners();
  }

  MovementFormViewModel({required this.customerId, this.movementToEdit}) {
    if (movementToEdit != null) {
      _oldAmount = movementToEdit!.amount;
      _isSale = movementToEdit!.isPayment;
      amountController.text = movementToEdit!.amount.abs().toString();
      notesController.text = movementToEdit!.notes ?? "";
      paymentMethod = movementToEdit!.paymentMethod;
      selectedTimestamp = movementToEdit!.date;
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedTimestamp.toDate());
    } else {
      final brasil = tz.getLocation('America/Sao_Paulo');
      final now = tz.TZDateTime.now(brasil);

      final date = tz.TZDateTime(
        brasil,
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );

      dateController.text = DateFormat('dd/MM/yyyy').format(date);
      selectedTimestamp = Timestamp.fromDate(date);
    }
  }

  void _errorMessage(String title, String message) {
    AppAlertDialog.show(
        context: navigatorKey.currentContext!,
        title: title,
        content: message,
        isError: true,
        buttonText: "Ok"
    );
  }

  double _getAmount() {
    return isSale ? -double.parse(amountController.text) : double.parse(amountController.text);
  }

  void updateDate(DateTime picked) {
    final brasil = tz.getLocation('America/Sao_Paulo');

    final date = tz.TZDateTime(
      brasil,
      picked.year,
      picked.month,
      picked.day,
    );

    selectedTimestamp = Timestamp.fromDate(date);
    dateController.text = DateFormat('dd/MM/yyyy').format(date);

    notifyListeners();
  }

  void onSubmit() async {
    Movement item = Movement(
        id: movementToEdit?.id,
        isPayment: isSale,
        date: selectedTimestamp,
        amount: _getAmount(),
        notes: notesController.text,
        paymentMethod: paymentMethod
    );

    if (movementToEdit != null) {
      await _updateMovement(item);
    } else {
      await _saveMovement(item);
    }
    
    await _updateBalance();

    Navigator.pop(navigatorKey.currentContext!);
  }

  Future<void> _saveMovement(Movement movement) async {
    try {
      await _service.addMovement(customerId, movement);
    } on Exception catch (e) {
      _errorMessage("Erro ao salvar a movimentação", e.toString());
    }
  }

  Future<void> _updateMovement(Movement movement) async {
    try {
      await _service.updateMovement(customerId, movement);
    } on Exception catch (e) {
      _errorMessage("Erro ao editar a movimentação", e.toString());
    }
  }

  Future<Customer?> _getCustomerById() async {
    Customer? response;

    try {
      response = await _customerService.getCustomerById(customerId);
    } on Exception catch(e) {
      _errorMessage("Erro ao buscar o cliente", e.toString());
    }

    return response;
  }

  Future<void> _updateBalance() async {
    Customer? customer = await _getCustomerById();

    if(customer == null) return;

    try {
      if (movementToEdit != null) {
        customer.balance = (customer.balance - _oldAmount) + _getAmount();
      } else {
        customer.balance += _getAmount();
      }

      await _customerService.updateBalance(customer.id!, customer.balance);

    } on Exception catch(e) {
      _errorMessage("Erro ao atualizar o saldo", e.toString());
    }
  }
}
