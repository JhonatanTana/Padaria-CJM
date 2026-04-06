import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/customer.dart';
import '../../../services/customer_service.dart';

class CustomerViewModel extends ChangeNotifier {
  final _service = CustomerService();
  List<Customer> _allCustomers = [];
  List<Customer> customers = [];
  String _searchQuery = "";
  StreamSubscription<List<Customer>>? _subscription;

  CustomerViewModel() {
    _startListening();
  }

  void _startListening() {
    _subscription?.cancel();
    _subscription = _service.getCustomers().listen((newList) {
      _allCustomers = newList;

      if (_searchQuery.isEmpty) {
        customers = List.from(_allCustomers);
      } else {
        _filterCustomers();
      }
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterCustomers();
    notifyListeners();
  }

  void _filterCustomers() {
    if (_searchQuery.isEmpty) {
      customers = List.from(_allCustomers);
    } else {
      customers = _allCustomers.where((customer) {
        final name = customer.name.toLowerCase();
        final search = _searchQuery.toLowerCase();
        return name.contains(search);
      }).toList();
    }
  }

  String currencyFormatter(double amount) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'pt_BR');
    return formatCurrency.format(amount);
  }

  Future<void> addCustomer(String name, bool canSale) async {
    final newCustomer = Customer(
      name: name,
      canSale: canSale,
      balance: 0.0,
    );
    await _service.addCustomer(newCustomer);
  }

  Future<void> updateCustomer(Customer customer) async {
    await _service.updateCustomer(customer);
  }

  Future<void> deleteCustomer(String id) async {
    await _service.deleteCustomer(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
