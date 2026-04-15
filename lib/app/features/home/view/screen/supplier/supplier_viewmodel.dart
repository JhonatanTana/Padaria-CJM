import 'dart:async';

import 'package:flutter/material.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_alert_dialog.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_button.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_input.dart';
import 'package:padaria_cjm2/app/features/home/view/widgets/app_text.dart';

import '../../../model/supplier.dart';
import '../../../services/supplier_service.dart';

class SupplierViewModel extends ChangeNotifier {
  final SupplierService _service = SupplierService();

  bool isLoading = false;
  StreamSubscription<List<Supplier>>? _subscription;
  List<Supplier> _allSuppliers = [];
  List<Supplier> suppliers = [];
  String _searchQuery = "";

  TextEditingController nameController = TextEditingController(text: "");

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

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterSuppliers();
    notifyListeners();
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

  void _errorMessage(BuildContext context, String message) {
    AppAlertDialog.show(
      context: context,
      title: 'Erro',
      content: message,
      buttonText: "Ok",
      isError: true,
    );
  }

  Future<void> deleteSupplier(BuildContext context, String supplierId) async{
    try {
      await _service.deleteSupplier(supplierId);
    } on Exception catch(e) {
      _errorMessage(context, e.toString());
    }
  }

  Future<void> updateSupplier(BuildContext context, Supplier supplier) async {
    try {
      await _service.updateSupplier(supplier);
    } on Exception catch(e) {
      _errorMessage(context, e.toString());
    }
  }

  Future<void> createSupplier(BuildContext context) async {
    try {
      final Supplier supplier = Supplier(
        name: nameController.text,
        balance: 0.0,
      );

      await _service.addSupplier(supplier);
    } on Exception catch(e) {
      _errorMessage(context, e.toString());
    }
  }

  void openSupplierModal(BuildContext context, Supplier? supplier) {
    nameController.text = supplier?.name ?? "";

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
          bottom: MediaQuery.of(modalContext).padding.bottom + 16,
          left: 8,
          right: 8,
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
                     updateSupplier(context, supplier);
                   } else {
                     createSupplier(context);
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

}