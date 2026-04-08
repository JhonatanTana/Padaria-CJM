import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/customer.dart';
import '../../../services/customer_service.dart';
import '../../widgets/app_input.dart';
import '../../widgets/app_text.dart';

class CustomerViewModel extends ChangeNotifier {
  final _service = CustomerService();
  List<Customer> _allCustomers = [];
  List<Customer> customers = [];
  String _searchQuery = "";
  StreamSubscription<List<Customer>>? _subscription;

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

  void openCustomerModal(BuildContext context, CustomerViewModel vm, {Customer? customer}) {
    final TextEditingController nameController = TextEditingController(text: customer?.name ?? "");
    bool canSale = customer?.canSale ?? true;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: customer == null ? "Novo Cliente" : "Editar Cliente",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              AppInput(
                controller: nameController,
                label: "Nome",
                inputType: TextInputType.text,
                autoFocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pode vender?"),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: canSale,
                      activeTrackColor: Color(0xFFD7263D),
                      onChanged: (value) {
                        setState(() {
                          canSale = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFD7263D)),
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
                  child: const AppText(
                    text: "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
