import 'dart:async';

import 'package:flutter/material.dart';

import '../../../model/customer.dart';
import '../../../services/customer_service.dart';
import '../../widgets/app_alert_dialog.dart';
import '../../widgets/app_input.dart';

class CustomerViewModel extends ChangeNotifier {
  final _service = CustomerService();
  List<Customer> _allCustomers = [];
  List<Customer> customers = [];
  String _searchQuery = "";
  StreamSubscription<List<Customer>>? _subscription;
  bool isLoading = false;

  CustomerViewModel() {
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

    _subscription = _service.getCustomers().listen((newList) {
      _allCustomers = newList;

      if (_searchQuery.isEmpty) {
        customers = List.from(_allCustomers);
      } else {
        _filterCustomers();
      }

      customers.sort((a, b) =>
          a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      isLoading = false;
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

  void _errorMessage(String message) {
    AppAlertDialog(
      title: 'Erro',
      content: message,
      buttonText: "Ok",
    );
  }

  Future<void> addCustomer(String name, bool canSale) async {
    try {
      final newCustomer = Customer(
        name: name,
        canSale: canSale,
        balance: 0.0,
      );

      await _service.addCustomer(newCustomer);
    } on Exception catch(e) {
      _errorMessage(e.toString());
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await _service.updateCustomer(customer);
    } on Exception catch(e) {
      _errorMessage(e.toString());
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _service.deleteCustomer(id);
    } on Exception catch(e) {
      _errorMessage(e.toString());
    }
  }

  void openCustomerModal(BuildContext context, CustomerViewModel vm, {Customer? customer}) {
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
                      vertical: 10,
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

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7263D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          if (customer == null) {
                            await vm.addCustomer(nameController.text, canSale);
                          } else {
                            customer.name = nameController.text;
                            customer.canSale = canSale;
                            await vm.updateCustomer(customer);
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Salvar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
