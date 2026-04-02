import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:padaria_cjm2/app/features/home/services/customer_service.dart';

import '../../../model/customer.dart';
import '../../../services/movements_service.dart';

class MovementsViewModel extends ChangeNotifier {
  final _customerService = CustomerService();
  final _service = MovementsService();

  String? customerId;
  Customer? customer;

  MovementsViewModel({this.customerId}) {
    _getCustomerById();
  }

  void _getCustomerById() async{
    if(customerId == null) return;
    try {
     customer = await _customerService.getCustomerById(customerId!);
     notifyListeners();
    }on Exception catch (e) {
      //TODO: Implemetar mensagem de erro
    }
  }

  String currencyFormatter(double amount) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(amount);
  }

}