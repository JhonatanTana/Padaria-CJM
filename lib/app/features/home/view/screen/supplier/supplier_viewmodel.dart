import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../../model/supplier.dart';
import '../../../services/supplier_service.dart';

class SupplierViewModel extends ChangeNotifier {
  SupplierService _service = SupplierService();

  bool isLoading = false;
  StreamSubscription<List<Supplier>>? _subscription;
  List<Supplier> _allSuppliers = [];
  List<Supplier> suppliers = [];
  String _searchQuery = "";

  SupplierViewModel() {
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _startListening() {
    _subscription?.cancel();
    isLoading = true;

    _subscription = _service.getSuppliers().listen((newList) {
      _allSuppliers = newList;

      if (_searchQuery.isEmpty) {
        suppliers = List.from(_allSuppliers);
      } else {
        _filterSuppliers();
      }

      suppliers.sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      isLoading = false;
      notifyListeners();
    });
  }

  void _filterSuppliers() {
    if (_searchQuery.isEmpty) {
      suppliers = List.from(_allSuppliers);
    } else {
      suppliers = _allSuppliers.where((customer) {
        final name = customer.name.toLowerCase();
        final search = _searchQuery.toLowerCase();
        return name.contains(search);
      }).toList();
    }
  }
}