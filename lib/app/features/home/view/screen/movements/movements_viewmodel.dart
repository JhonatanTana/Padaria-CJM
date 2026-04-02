import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padaria_cjm2/app/features/home/model/movements.dart';
import 'package:padaria_cjm2/app/features/home/services/customer_service.dart';

import '../../../model/customer.dart';
import '../../../services/movements_service.dart';

class MovementsViewModel extends ChangeNotifier {
  final _customerService = CustomerService();
  final _service = MovementsService();

  String? customerId;
  Customer? customer;
  StreamSubscription<List<Movement>>? _subscription;
  List<Movement> movements = [];

  MovementsViewModel({this.customerId}) {
    _getCustomerById();
    _getMovements();
  }

  void _getCustomerById() async {
    if (customerId == null) return;
    try {
      customer = await _customerService.getCustomerById(customerId!);
      notifyListeners();
    } on Exception catch (e) {
      //TODO: Implemetar mensagem de erro
    }
  }

  void _getMovements() {
    if (customerId == null) return;

    _subscription?.cancel();
    _subscription = _service.getMovementsByCustomerId(customerId!).listen((newList) {
      movements = newList;
      notifyListeners();
    }, onError: (e) {
      // TODO: Implementar mensagem de erro
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  String currencyFormatter(double amount) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(amount);
  }

  String dateFormatter(DateTime date, bool includeTime) {
    late DateFormat formatter;

    if (includeTime) {
      formatter = DateFormat('dd/MM/yyyy HH:mm');
    } else {
      formatter = DateFormat('dd/MM/yyyy');
    }

    return formatter.format(date);
  }

  double get totalBalance {
    double total = 0.0;

    for (var movement in movements) {
      total += movement.amount;
    }

    if(customer != null) {
      if(total != customer!.balance) {
        //TODO: Implementar mensagem de erro
      }
    }

    return total;
  }
}